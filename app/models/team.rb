class Team < ActiveRecord::Base
  belongs_to :tournament
  
  has_many :team_members, :dependent => :destroy
  has_many :members, :through => :team_members
  has_one  :captain, :through => :team_members, :conditions => ['state = ?', 'captain'], :source => :member
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  validate :restricted_names
  
  # def captain
  #   team_members.find(:first, :conditions => {:state => 'captain'}).participation.participant
  # end
  
  def captain=(user)
    self.team_members.build(:member => user, :state => 'captain')
  end
  
  def restricted_names
    errors.add(:name, 'is not allowed') if ['Participants', 'Officials', 'Pending Approval'].include?(name.strip)
  end
end
