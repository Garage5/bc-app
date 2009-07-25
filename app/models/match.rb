class Match < ActiveRecord::Base
  belongs_to :round
  belongs_to :winner, :class_name => "User"
  belongs_to :player_one, :class_name => "User"
  belongs_to :player_two, :class_name => "User"
  
  has_many :comments, :as => :commentable
  
  def winner_is?(player)
    self.winner == player
  end
end
