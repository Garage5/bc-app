class TeamsController < ApplicationController
  before_filter :find_instance
  before_filter :find_tournament
  before_filter :login_required
  
  def create
    if current_user.is_hosting?(@tournament)
      flash[:error] = 'Officials can\'t create teams.'
    else
      @team = Team.create({:tournament_id => @tournament.id}.merge(params[:team]))
      # find the participants the user requested
      parts = @tournament.participations.find(:all, :conditions => {:participant_id => params[:user_ids] + [current_user.id], :state => 'active'})
      parts.reject! do |part|
        # can't add a participant that accepted to join other team
        unless part.team_memberships.exists?(:state => 'active')
          @team.team_members.create(:participation => part, :state => (part.participant_id == current_user.id ? 'captain' : 'active'))
        end
      end
    end
    redirect_to tournament_participants_path(@tournament)
  end
  
  def update
    @team = @tournament.teams.find(params[:id])
    if current_user.is_hosting?(@tournament) || current_user == @team.captain
      # change the name, if we can
      if @team.update_attributes(params[:team])
        # find the participants the user requested
        parts = @tournament.participations.find(:all, :conditions => {:participant_id => params[:user_ids], :state => 'active'})
        parts.each do |part|
          # skip if the guy is invited for this team or accepted another
          next if @team.team_members.exists?(["participation_id = ? AND (state IN ('active', 'captain') OR team_id = ?)", part.id, @team.id])
          # add new members
          @team.team_members.create(:participation => part, :state => 'active')
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
    @team = @tournament.teams.find(params[:id])
    if current_user.is_hosting?(@tournament) || current_user == @team.captain
      @team.destroy
    else
      flash[:error] = "You are not allowed to delete this team."
    end
    redirect_to tournament_participants_path(@tournament)
  end
end
