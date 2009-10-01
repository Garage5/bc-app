class MatchesController < ApplicationController
  before_filter :find_tournament
  before_filter :login_required, :only => :submit_result
  before_filter :must_be_participant, :only => :submit_result
  
  def show
    @match = Match.find(params[:id], :include => [:slots, {:comments => [:author, :attachments]}])
    @slot = @match.slots.find_by_player_id(current_user.id)
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
  
  def submit_result
    @match.submit_results(@player, params[:result])
    redirect_to [@tournament, @match]
  end
  
  def disqualify_player
    if ![:player_one, :player_two].include?(params[:p].to_sym)
      redirect_to [:brackets, @tournament] 
    else
      @match = Match.find(params[:id])
      @match.disqualify(params[:p].to_sym)
      redirect_to [:brackets, @tournament]
    end
  end
  
  def declare_winner
    if ![:player_one, :player_two].include?(params[:p].to_sym)
      redirect_to [:brackets, @tournament] 
    else
      @match = Match.find(params[:id])
      @match.advance(params[:p].to_sym)
      redirect_to [:brackets, @tournament]
    end
  end

  protected
  def must_be_participant
    @match = Match.find(params[:id])
    unless @player = @match.is_match_player(current_user)
      flash[:error] = 'You are not a participant of this match.'
      redirect_to [@tournament, @match]
    end
  end
end
