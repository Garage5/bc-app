class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :participations, :dependent => :destroy
  has_many :tournaments, :through => :participations
  
  validates_acceptance_of :terms_of_service, :on => :create
  validates_length_of :login, :within => 3..13
  
  def join_tournament(tournament)
    tournament.participants << self
  end
  
  def is_participant_of?(tournament)
    Participation.find_by_participant_id_and_tournament_id(self.id, tournament.id)
  end
end
