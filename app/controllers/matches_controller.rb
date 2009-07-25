class MatchesController < ApplicationController
  before_filter :find_tournament
  
  def show
    @match = Match.find(params[:id], :include => {:comments => [:author, :attachments]})
  end
  
  def update
    @match = Match.find(params[:id])
    if @match.update_attributes(params[:match])
      flash[:notice] = "Successfully updated match."
      redirect_to @match
    else
      render :action => 'edit'
    end
  end
end
