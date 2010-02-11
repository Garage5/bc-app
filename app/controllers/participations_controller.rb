class ParticipationsController < InheritedResources::Base
  belongs_to :tournament, :instance_name => :tournament
  
  # before_filter :authenticate_user!, :except => [:index]
  # before_filter :must_be_host, :except => [:index, :create, :deny, :accept]
  # before_filter :tournament_not_started, :only => [:create, :accept, :deny]
  
  def index
    @officials = parent.participations.cohost
    @pending = parent.participations.pending
    @active = parent.participations.accepted
    index!
  end
  
  def add_cohost
    user = User.find(:first, :conditions => {:username => params[:user]})

    unauthorized! if cannot?(:add_cohost, parent)

    if user
      if user.is_cohosting?(parent)
        flash[:error] = "This user is already hosting or co-hosting this tournament."
      elsif user.is_participant_of?(parent)
        flash[:error] = "You can not add a participant as a co-host. Please remove the user from participants first."
      else
        participation = user.cohost_tournament parent
      end
    else
      flash[:error] = "No user with this BattleID or e-mail was found."
    end
    redirect_to tournament_participants_path(parent)
  end
  
  def new
    unauthorized! if cannot?(:join, parent)
    new!
  end
  
  def create
    unauthorized! if cannot?(:join, parent)
    participation = current_user.join_tournament(parent)
    if participation
      flash[:notice] = "You are now pending acceptance into '#{parent.name}'"
    end
    redirect_to parent
  end
  
  def accept
    @participation = Participation.find_by_participant_id_and_tournament_id(params[:participant], parent.id)
    unauthorized! if cannot? :accept, @participation
    if @participation.accept!
      @officials = parent.officials
      render :layout => false
    else
      render :nothing => true
    end
  end
  
  def deny
    @participation = Participation.find_by_participant_id_and_tournament_id(params[:participant], parent.id)
    unauthorized! if cannot? :destroy, @participation
    @participation.destroy
    respond_to do |format|
      format.html { redirect_to tournament_participants_path(parent) }
      format.js { render :text => ("location.href = '#{tournament_participants_path(parent)}'") }
    end
  end

  protected
  
  def tournament_not_started
    if parent.started?
      flash[:error] = "Participants cannot be added or removed once a tournament has started."
      redirect_back_or_default tournament_participants_path(parent)
    end  
  end
end
