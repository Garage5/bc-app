class ParticipationsController < ApplicationController
  before_filter :find_tournament
  before_filter :login_required, :except => [:index]
  before_filter :must_be_host, :except => [:index, :create, :deny]
  
  def index
    @pending_participants = @tournament.pending_participants
    @active_participants = @tournament.active_participants
  end
  
  def add_cohost
    user = User.find(:first, :conditions => ['login = ? OR email = ?', params[:user], params[:user]])
    if user
      if user.is_hosting?(@tournament)
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
    current_user.join_tournament @tournament
    redirect_to @tournament
  end
  
  def accept
    ids = params[:participant_ids] || []
    @participants = User.find(ids)
    if !@participants.empty?
      Participation.update_all("state = 'active'", 
      "participant_id IN(#{ids.join(',')}) AND tournament_id = #{@tournament.id}")
    end
    respond_to do |format|
      format.html { redirect_to tournament_participants_path(@tournament) }
      format.js { render :text => ("location.href = '#{tournament_participants_path(@tournament)}'") }
    end
  end
  
  def deny
    ids = params[:participant_ids] || []
    ids = [params[:participant]] if params[:participant]
    @participants = User.find(ids)
    if !ids.blank?
      @participants.delete_if do |user|
        !current_user.is_hosting?(@tournament) && user != current_user
      end
      if !@participants.blank?
        parts = Participation.find(:all, :conditions => {:participant_id => @participants.collect{|p| p.id}, :tournament_id => @tournament.id})
        parts.each { |p| p.destroy }
      end
    end
    respond_to do |format|
      format.html { redirect_to tournament_participants_path(@tournament) }
      format.js { render :text => ("location.href = '#{tournament_participants_path(@tournament)}'") }
    end
  end

  def update
    @participation = Participation.find(params[:id])
    if @participation.update_attributes(params[:participation])
      flash[:notice] = "Successfully updated participation."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
end
