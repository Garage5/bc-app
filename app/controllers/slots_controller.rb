class SlotsController < ApplicationController
  before_filter :find_tournament
  before_filter :find_slot
  before_filter :must_not_have_winner
  
  def manage
    render :layout => false
  end
  
  def advance
    redirect_to [:brackets, @tournament] if @slot.advance!
  end
  
  def revert
    redirect_to [:brackets, @tournament] if @slot.revert!    
  end
  
  def disqualify
    redirect_to [:brackets, @tournament] if @slot.disqualify!
  end
  
  def won
    redirect_to [:brackets, @tournament] if @slot.won!
  end
  
  def lost
    redirect_to [:brackets, @tournament] if @slot.lost!
  end

  private
  def find_slot
    @match = Match.find(params[:match_id])
    @slot = @match.slots.find(params[:id])
  end
  
  def must_not_have_winner
    if !@match.winner.nil?
      flash[:error] = 'Match already has been decided.'
      redirect_to [:brackets, @tournament]
    end
  end
end
