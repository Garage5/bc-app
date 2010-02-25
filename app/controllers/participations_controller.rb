class ParticipationsController < InheritedResources::Base
  belongs_to :tournament, :instance_name => :tournament
  respond_to :html
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
    unauthorized! if cannot?(:add_cohost, parent)
    if request.post?
      @user = User.find(:first, :conditions => {:username => params[:user]})
      if @user
        @participation = @tournament.participations.create(:participant => @user, :state => 'cohost')
        if @participation.save
          render_success tournament_participants_path(parent)
        else
          render_alert(@participation.errors.first[1])
        end
      else
        render_alert('BattleID not found.')
      end
    else
      render :layout => false
    end
  end
  
  def new
    unauthorized! if cannot?(:join, parent)
    new! do |format|
      format.html { render :layout => false }
    end
  end
  
  def create
    unauthorized! if cannot?(:join, parent)

    unless @tournament.use_teams?
      @participation = Participation.new(:participant => current_user, :tournament => parent)
    else
      @participation = Team.new(params[:participation])
      @participation.captain = current_user
      @participation.tournament = parent
    end

    create! do |success, failure|
      success.html { render_success tournament_participants_path(@tournament) }
      failure.html { render_alert @participation.errors.full_messages.join('\n') }
    end
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
      format.js   { render :text => ("location.href = '#{tournament_participants_path(parent)}'") }
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
