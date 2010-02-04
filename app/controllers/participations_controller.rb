class ParticipationsController < ApplicationController
  before_filter :find_tournament
  # before_filter :authenticate_user!, :except => [:index]
  # before_filter :must_be_host, :except => [:index, :create, :deny, :accept]
  # before_filter :tournament_not_started, :only => [:create, :accept, :deny]
  
  def index
    @officials = @tournament.participations.cohost
    @pending = @tournament.participations.pending
    @active = @tournament.participations.accepted
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
    unauthorized! if cannot?(:join, @tournament)
    participation = current_user.join_tournament(@tournament)
    if participation
      flash[:notice] = "You are now pending acceptance into '#{@tournament.name}'"
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
  end
  
  def deny
    @participation = Participation.find_by_participant_id_and_tournament_id(params[:participant], @tournament.id)
    unauthorized! if cannot? :destroy, @participation
    @participation.destroy
    respond_to do |format|
      format.html { redirect_to tournament_participants_path(@tournament) }
      format.js { render :text => ("location.href = '#{tournament_participants_path(@tournament)}'") }
    end
  end

  protected
  
  def tournament_not_started
    if @tournament.started?
      flash[:error] = "Participants cannot be added or removed once a tournament has started."
      redirect_back_or_default tournament_participants_path(@tournament)
    end  
  end
end
