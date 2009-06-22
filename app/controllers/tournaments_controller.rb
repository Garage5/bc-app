class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all
  end
  
  def show
    @tournament = Tournament.find(params[:id])
  end
  
  def new
    @tournament = Tournament.new
  end
  
  def create
    @tournament = Tournament.new(params[:tournament])
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
end
