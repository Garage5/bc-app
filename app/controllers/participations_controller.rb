class ParticipationsController < ApplicationController
  before_filter :login_required
  before_filter :find_tournament
  
  def create
    current_user.join_tournament @tournament
    redirect_to @tournament
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
  
  def destroy
    @participation = Participation.find(params[:id])
    @participation.destroy
    flash[:notice] = "Successfully destroyed participation."
    redirect_to root_url
  end
end
