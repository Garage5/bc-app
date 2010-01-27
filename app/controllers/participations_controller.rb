class ParticipationsController < ApplicationController
  before_filter :find_tournament
  # before_filter :authenticate_user!, :except => [:index]
  # before_filter :must_be_host, :except => [:index, :create, :deny, :accept]
  # before_filter :tournament_not_started, :only => [:create, :accept, :deny]
  
  def index
    @officials = [current_account.admin] + @tournament.cohosts
    @pending = @tournament.pending_participants
    
    if @tournament.use_teams?
      @teams = @tournament.teams.all(:include => :members)
      @active = @tournament.active_participants.all(
        :joins => 'LEFT JOIN team_members ON team_members.member_id = users.id', 
        :conditions => {
          :team_members => {:id => nil},
          :participations => {:tournament_id => @tournament.id}
        }
      )
    else
      @active = @tournament.active_participants
    end
  end
  
  def add_cohost
    user = User.find(:first, :conditions => {:username => params[:user]})

    unauthorized! if cannot?(:add_cohost, @tournament)

    if user
      if user.is_cohosting?(@tournament)
        flash[:error] = "This user is already hosting or co-hosting this tournament."
      elsif user.is_participant_of?(@tournament)
        flash[:error] = "You can not add a participant as a co-host. Please remove the user from participants first."
      else
        participation = user.cohost_tournament @tournament
      end
    else
      flash[:error] = "No user with this BattleID or e-mail was found."
    end
    redirect_to tournament_participants_path(@tournament)
  end
  
  def create
    unauthorized!('You are already a participant/pending participant in this tournament') if cannot?(:join, @tournament)
    participation = current_user.join_tournament(@tournament)
    if participation
      flash[:notice] = "You are now pending acceptance into '#{@tournament.name}'"
    else
      flash[:error] = "Uh oh. Something happened that wasn't supposed to happen."
    end
    redirect_to @tournament
  end
  
  def accept
    @participation = Participation.find_by_participant_id_and_tournament_id(params[:participant], @tournament.id)
    unauthorized! if cannot? :accept, @participation
    if @participation.accept!
      @officials = @tournament.officials
      render :layout => false
    else
      render :nothing => true
    end
    
    # ids = params[:participant_ids] || []
    # if ids.size > @tournament.open_slots
    #   flash[:error] = "Cannot accept #{ids.size} participants because there are only #{@tournament.open_slots} open slots."
    # else
    #   @participants = User.find(ids)
    #   if !@participants.empty?
    #     Participation.update_all("state = 'active'", 
    #     "participant_id IN(#{ids.join(',')}) AND tournament_id = #{@tournament.id}")
    #   end
    # end
    
    # redirect_to tournament_participants_path(@tournament)
  end
  
  def deny
    @participation = Participation.find_by_participant_id_and_tournament_id(params[:participant], @tournament.id)
    unauthorized! if cannot? :destroy, @participation
    @participation.destroy
    
    # if !ids.blank?
    #   @participants.delete_if do |user|
    #     !current_user.is_hosting?(current_account) && user != current_user
    #   end
    #   if !@participants.blank?
    #     parts = Participation.find(:all, :conditions => {:participant_id => @participants.collect{|p| p.id}, :tournament_id => @tournament.id})
    #     parts.each { |p| p.destroy }
    #   end
    # end
    # 
    respond_to do |format|
      format.html { redirect_to tournament_participants_path(@tournament) }
      format.js { render :text => ("location.href = '#{tournament_participants_path(@tournament)}'") }
    end
  end

  # def update
  #   @participation = Participation.find(params[:id])
  #   if @participation.update_attributes(params[:participation])
  #     flash[:notice] = "Successfully updated participation."
  #     redirect_to root_url
  #   else
  #     render :action => 'edit'
  #   end
  # end
  
  protected
  
  def tournament_not_started
    if @tournament.started?
      flash[:error] = "Participants cannot be added or removed once a tournament has started."
      redirect_back_or_default tournament_participants_path(@tournament)
    end  
  end
end
