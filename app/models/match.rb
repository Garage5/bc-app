class Match < ActiveRecord::Base
  belongs_to :round
  belongs_to :tournament
  belongs_to :winner, :class_name => "User", :foreign_key => "winner_id"
  
  has_many :comments, :as => :commentable

  has_many :slots, :order => 'position asc'
  has_many :players, :through => :slots
  
  acts_as_list :scope => :round
  
  def has_player?(user)
    user == self.slots[0].player || self.slots[1].player ? true : false
  end
  
  def next
    rounded = self.position % 2 == 0 ? self.position : self.position + 2 - (self.position % 2)
    self.round.lower_item.matches.first(:conditions => {:position => (rounded / 2)})
  end
  
  def dispute!
    self.update_attributes(:status => 'disputed')
    self.tournament.events.create(
      :target_id => self.id, :target_type => self.class.to_s,
      :event_type => 'dispute', :action => 'posted',
      :message => "A dispute has occured between #{self.slots[0].player.login} and #{self.slots[1].player.login}",
      :actor => 'someone')
  end
  
  def disputed?; self.status == 'disputed'; end
  
  def winner_is?(player)
    self.winner == player
  end

  def winner_position
    return 1 if self.slots[0].player.id == self.winner_id
    return 2 if self.slots[1].player.id == self.winner_id
  end

  def child_match_in_next_round
    self.round.lower_item.matches.first(:conditions => {:position => find_child_match_position})
  end
  
  def find_child_match_position
    # round up to the nearest even number (2, 4, 6, etc...)
    rounded = self.position % 2 == 0 ? self.position : self.position + 2 - (self.position % 2)
    
    # child match will be the position of each match rounded to the nearest even number divided by 2
    # i.e. match '3' rounded to nearest even equals '4', the child match will be 4 / 2: 2nd match in the next round
    return rounded / 2
  end
end
