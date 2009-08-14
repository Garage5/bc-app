class TournamentsController < ApplicationController
  before_filter :find_instance
  before_filter :find_tournament, :except => [:new, :create]
  before_filter :login_required, :except => [:index, :show, :brackets, :participants, :rules]
  
  def index
    @tournaments = Tournament.all
  end
  
  def show
    @tournament = Tournament.find(params[:id])
  end
  
  def brackets
    @rounds = Round.all(:conditions => {:tournament_id => @tournament.id}, :include => {:matches => [:player_one, :player_two]})
  end
  
  def participants
    @tournament = Tournament.find(params[:id])
  end
  
  def new
    if params[:t]
      if @temp = Tournament.find(params[:t])
        flash[:notice] = "Loaded template based on '#{@temp.name}'"
        @tournament = Tournament.new(@temp.attributes)
      else
        flash[:error] = 'Tournament for template not found.'
      end
    else
      @tournament = Tournament.new
    end
  end
  
  def create
    @tournament = @instance.tournaments.build(params[:tournament])
    if @tournament.save
      flash[:notice] = "Successfully created tournament."
      redirect_to @tournament
    else
      render :action => 'new'
    end
  end
  
  def edit
    @tournament = Tournament.find(params[:id])
  end
  
  def update
    @tournament = Tournament.find(params[:id])
    if @tournament.update_attributes(params[:tournament])
      flash[:notice] = "Successfully updated tournament."
      redirect_to @tournament
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy
    flash[:notice] = "Successfully destroyed tournament."
    redirect_to tournaments_url
  end
  
  def rules
  end
  
  def load_template
    @tournament = Template.find(params[:template_id])
    render :action => 'new'
  end

  def start
    redirect_to brackets_tournament_path(@tournament) if @tournament.start
  end
end
