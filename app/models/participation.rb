class Participation < ActiveRecord::Base
  belongs_to :participant, :class_name => 'User'
  belongs_to :tournament, :dependent => :destroy
  belongs_to :account
  
  validates_uniqueness_of :participant_id, :scope => :tournament_id
  validate :participant_cannot_be_host
  
  def accept!
    self.state = 'active'
    self.save
  end
  
  def participant_cannot_be_host
    tournament = Tournament.find(self.tournament_id)    
    errors.add_to_base('Officials cannot participate in tournaments') if 
      tournament.account.admin_id == self.participant_id
  end
end
