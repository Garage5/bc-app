class Participation < ActiveRecord::Base
  named_scope :cohost, :conditions => {:state => 'cohost'}, :include => :participant
  named_scope :accepted, :conditions => ['state != ? AND accepted_at IS NOT NULL', 'cohost'], :include => :participant
  named_scope :pending, :conditions => ['state != ? AND accepted_at IS NULL', 'cohost'], :include => :participant
  
  belongs_to :participant, :class_name => 'User'
  belongs_to :tournament
  belongs_to :account
  
  validates_uniqueness_of :participant_id, :scope => :tournament_id, :message => 'User is already participating in this tournament.'
  
  def accept!
    update_attributes(:accepted_at => Time.now)
  end
end
