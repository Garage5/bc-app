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
    Participation.exists?(:participant_id => self.id, :tournament_id => tournament.id)
  end
  
  def is_eligible_to_join?(tournament)
    if self.id == tournament.instance.host_id || self.is_participant_of?(tournament)
      false
    else
      true
    end
  end
  
end
