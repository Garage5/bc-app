class SlotsController < ApplicationController
  before_filter :find_tournament
  before_filter :find_slot
  before_filter :must_not_have_winner
  before_filter :must_be_participant_or_host
  before_filter :must_not_have_result_if_participant, :except => [:manage]
  
  def manage
    render :layout => false
  end
  
  def advance
    unauthorized! if cannot? :advance, @slot
    @slot.advance!
    redirect_to [:brackets, @tournament]
  end
  
  def revert
    unauthorized! if cannot? :revert, @slot
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
  
  def must_be_participant_or_host
    @current_user_is_participant = @slot.player == current_user
    unless @current_user_is_participant or current_user.is_cohosting?(@tournament)
      flash[:error] = 'You do not have permission to do that.'
      redirect_to [:brackets, @tournament]
    end
  end
  
  def must_not_have_winner
    if !@match.winner.nil?
      flash[:error] = 'Match has already been decided.'
      redirect_to [:brackets, @tournament]
    end
  end
  
  def must_not_have_result_if_participant
    if @current_user_is_participant
      if !@slot.result.nil?
        flash[:error] = 'Result has already been submitted for this slot.'
        redirect_to [:brackets, @tournament]
      end
    end
  end
end
