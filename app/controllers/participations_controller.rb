class ParticipationsController < ApplicationController
  before_filter :login_required, :except => [:index]
  before_filter :find_tournament
  
  def index
    @pending_participants = @tournament.pending_participants
    @active_participants = @tournament.active_participants
  end
  
  def create
    current_user.join_tournament @tournament
    redirect_to @tournament
  end
  
  def accept
    redirect_to tournament_participants_path(@tournament) if Participation.update_all("state = 'active'", 
      "participant_id IN(#{params[:participants].keys.join(',')}) AND tournament_id = #{@tournament.id}")
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
