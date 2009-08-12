class TeamsController < ApplicationController
  before_filter :find_instance
  before_filter :find_tournament
  before_filter :find_team, :except => :create
  before_filter :login_required
  
  def create
    if current_user.is_hosting?(@tournament)
      flash[:error] = 'Officials can\'t create teams.'
    elsif !@tournament.use_teams?
      flash[:error] = 'This tournament is not based on teams.'
    else
      @team = Team.new({:tournament_id => @tournament.id}.merge(params[:team]))
      # find the participants the user requested
      parts = @tournament.participations.find(:all, :conditions => {:participant_id => [current_user.id] + (params[:user_ids] || []), :state => 'active'}, :order => "(participant_id = #{current_user.id}) DESC")
      parts.each do |part|
        # can't add a participant that accepted to join other team
        unless part.team_memberships.exists?(:state => ['active', 'captain'])
          @team.team_members.build(:participation => part, :state => (part.participant_id == current_user.id ? 'captain' : 'pending'))
        end
      end
      if !@team.save
        flash[:error] = "Could not create the team: #{@team.errors.full_messages.join(",")}"
      end
      # creating a team you decline other invitations for you
      current_user.team_memberships_in(@tournament, true).each do |memb|
        memb.destroy unless memb.team == @team
      end
    end
    redirect_to tournament_participants_path(@tournament)
  end
  
  def update
    params[:user_ids] ||= []
    if current_user.is_hosting?(@tournament) || current_user == @team.captain
      # change the name, if we can
      if @team.update_attributes(params[:team])
        # find the participants the user requested
        parts = @tournament.participations.find(:all, :conditions => {:participant_id => params[:user_ids], :state => 'active'})
        parts.each do |part|
          # skip if the guy is invited for this team or accepted another
          next if @team.team_members.exists?(["participation_id = ? AND (state IN ('active', 'captain') OR team_id = ?)", part.id, @team.id])
          # add new members
          @team.team_members.create(:participation => part, :state => 'pending')
        end
        # deletes the members that need to be
        @team.team_members.each do |memb|
          memb.destroy if memb.state != 'captain' && !(params[:user_ids].include?(memb.participation.participant_id.to_s))
        end
      else
        flash[:error] = "Name #{@team.errors_on(:name)}"
      end
    end
    redirect_to tournament_participants_path(@tournament)
  end
  
  def destroy
    if current_user.is_hosting?(@tournament) || current_user == @team.captain
      @team.destroy
    else
      flash[:error] = "You are not allowed to delete this team."
    end
    redirect_to tournament_participants_path(@tournament)
  end
  
  def join
    current_user.join_team(@team)
    redirect_to tournament_participants_path(@tournament)
  end
  
  def decline
    current_user.decline_team(@team)
    redirect_to tournament_participants_path(@tournament)
  end
  
  private
    def find_team
      @team = @tournament.teams.find(params[:id])
    end
end
