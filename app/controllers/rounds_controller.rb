class RoundsController < ApplicationController
  def update
    @round = Round.find(params[:id])
    if @round.update_attributes(params[:round])
      flash[:notice] = "Successfully updated round."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
end
