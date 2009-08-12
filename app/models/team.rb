class Team < ActiveRecord::Base
  belongs_to :tournament
  has_many :team_members, :dependent => :destroy
  has_many :participations, :through => :team_members
  validates_presence_of :name
  validates_uniqueness_of :name
  
  validate :restricted_names
  
  def captain
    team_members.find(:first, :conditions => {:state => 'captain'}).participation.participant
  end
  
  def restricted_names
    errors.add(:name, 'is not allowed') if ['Participants', 'Officials', 'Pending Approval'].include?(name.strip)
  end
end
