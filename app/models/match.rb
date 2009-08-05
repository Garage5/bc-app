class Match < ActiveRecord::Base
  belongs_to :round
  belongs_to :winner, :class_name => "User"
  belongs_to :player_one, :class_name => "User"
  belongs_to :player_two, :class_name => "User"
  
  has_many :comments, :as => :commentable
  
  acts_as_list :scope => :round
  
  def is_match_player(user)
    case user
    when self.player_one
      :player_one
    when self.player_two
      :player_two
    else
      false
    end
  end
  
  def disputed?; self.status == 'disputed'; end
  
  def winner_is?(player)
    self.winner == player
  end
  
  def submit_results(player, won_or_lost)
    won_or_lost = won_or_lost.to_s
    self.send(player.to_s + '_result=', won_or_lost) # set result for player
    opponent = player == :player_one ? :player_two : :player_one
    opponent_result = player == :player_one ? self.player_two_result : self.player_one_result
    
    if opponent_result == 'lost' && won_or_lost == 'won' # if both agree that player is winner
      self.winner = self.send(player)
      self.advance(player)
    elsif opponent_result == 'won' && won_or_lost == 'lost' # if both agree that opponent is winner
      self.winner = self.send(opponent)
      self.advance(opponent)
    elsif opponent_result == won_or_lost # if both have the same result
      self.status = 'disputed'
    end
    save
  end

  def advance(player)
    next_match = child_match_in_next_round
    # add player to correct slot in next match
    case player
    when :player_one
      if self.position.odd?
        next_match.player_one = self.player_one
      else
        next_match.player_two = self.player_one
      end
    when :player_two
      if self.position.odd?
        next_match.player_one = self.player_two
      else
        next_match.player_two = self.player_two
      end
    end
    next_match.save
  end
  
  def child_match_in_next_round
    self.round.lower_item.matches.first(:conditions => {:position => find_child_match_position})
  end
  
  def find_child_match_position
    # round up to the nearest even number (2, 4, 6, etc...)
    rounded = self.position % 2 == 0 ? self.position : self.position + 2 - (self.position % 2)
    
    # child match will be the position of each match rounded to the nearest 2 divided by 2
    # i.e. match '3' rounded to nearest 2 equals '4', the child match will be 4 / 2: 2nc match in the next round
    return rounded / 2
  end
end
