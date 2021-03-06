class Match < ActiveRecord::Base
  named_scope :by_pos, lambda {|pos| {:conditions => {:position => pos}}}
  
  belongs_to :round
  belongs_to :tournament
  belongs_to :winner, :polymorphic => true
  
  has_many :comments, :as => :commentable
  attr_readonly :comments_count
  
  has_many :slots, :order => 'position asc'
  # has_many :players, :through => :slots
  
  acts_as_list :scope => :round

  def subject
    "#{self.slots[0].player.login} vs. #{self.slots[1].player.login}"
  end
  
  def active?
    self.slots[0].player.nil? || self.slots[1].player.nil? ? false : true
  end
  
  def has_player?(user)
    user == self.slots[0].player || self.slots[1].player
  end
  
  def next
    next_round = self.round.lower_item
    match = next_round.matches.first({:conditions => {:position => find_child_match_position}})
    return match
  end
  
  def dispute!
    self.update_attributes(:status => 'disputed')
    self.tournament.events.create(
      :event_type => 'dispute',
      :data => Hashie::Mash.new({
        :opponents => [self.slots[0].player.login, self.slots[1].player.login]
      })
    )
  end
  
  def disputed?; self.status == 'disputed'; end
  
  def winner_is?(player)
    self.winner_id == player.id
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
