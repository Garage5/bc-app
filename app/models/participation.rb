class Participation < ActiveRecord::Base
  named_scope :cohost, :conditions => {:state => 'cohost'}, :include => :participant
  named_scope :accepted, :conditions => 'accepted_at IS NOT NULL', :include => :participant
  named_scope :pending, :conditions => 'accepted_at IS NULL', :include => :participant
  
  belongs_to :participant, :class_name => 'User'
  belongs_to :tournament
  belongs_to :account
  
  validates_uniqueness_of :participant_id, :scope => :tournament_id
  validate :participant_cannot_be_host
  
  def accept!
    update_attributes(:accepted_at => Time.now)
  end
  
  def participant_cannot_be_host
    tournament = Tournament.find(self.tournament_id)    
    errors.add_to_base('Officials cannot participate in tournaments') if 
      tournament.account.admin_id == self.participant_id
  end
end
