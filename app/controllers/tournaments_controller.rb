class TournamentsController < ApplicationController
  before_filter :find_instance
  before_filter :find_tournament, :except => [:new, :create, :calendar]
  before_filter :login_required, :except => [:index, :show, :brackets, :participants, :rules, :calendar]
  
  def calendar
    args = {}
    if params[:year]
      args[:show_date] = Date.new(params[:year].to_i, params[:month].to_i, 1)
    else
      r = []
      0.upto(4) { |n| r << "rounds_#{n}_start_date" }
      r += %w(registration_start_date registration_end_date)
      r.each do |field|
        begin
          d = params[field].split('-')
          args[field.to_sym] = Date.new(d[0].to_i, d[1].to_i, d[2].to_i)
        rescue
          # invalid/empty dates are ignored
        end
      end
      args[:show_date] = args[params[:field].to_sym]
      logger.debug(args.inspect)
    end
    render(:partial => 'layouts/calendar', :locals => args)
  end
  
  def index
    @tournaments = Tournament.all
  end
  
  def show
    @tournament = Tournament.find(params[:id])
  end
  
  def brackets
    @rounds = Round.all(:conditions => {:tournament_id => @tournament.id}, :include => {:matches => {:slots => :player}})
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
    # temporarily clear out the Round data until it's settled
    params[:tournament].delete(:rounds_attributes)
    
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
