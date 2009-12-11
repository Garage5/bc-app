class SlotsController < ApplicationController
  before_filter :find_tournament
  before_filter :find_slot
  before_filter :must_not_have_winner
  
  def manage
    render :layout => false
  end
  
  def advance
    @slot.advance!
    redirect_to [:brackets, @tournament]
  end
  
  def revert
    @slot.revert!
    redirect_to [:brackets, @tournament]
  end
  
  def disqualify
    @slot.disqualify!
    redirect_to [:brackets, @tournament]
  end
  
  def won
    @slot.won!
    redirect_to [:brackets, @tournament] 
  end
  
  def lost
    @slot.lost!
    redirect_to [:brackets, @tournament]
  end

  private
  def find_slot
    @match = Match.find(params[:match_id])
    @slot = @match.slots.find(params[:id])
  end
  
  def must_by_participant_or_host
    unless @slot.player == current_user or current_user.is_cohosting?(@tournament)
      flash[:error] = 'You do not have permission to do that.'
      redirect_to [:brackets, @tournament]
    end
  end
  
  def must_not_have_winner
    if !@match.winner.nil?
      flash[:error] = 'Match already has been decided.'
      redirect_to [:brackets, @tournament]
    end
  end
end
