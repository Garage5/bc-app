class Match < ActiveRecord::Base
  named_scope :for_round, lambda {|r| {:conditions => {:round => r}}}
  
  belongs_to :winner, :class_name => "User"
  belongs_to :player_one, :class_name => "User"
  belongs_to :player_two, :class_name => "User"
  
  has_many :comments
  
  def winner_is?(player)
    self.winner == player
  end
end
