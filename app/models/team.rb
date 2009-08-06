class Team < ActiveRecord::Base
  belongs_to :tournament
  has_many :team_members, :dependent => :destroy
  has_many :participations, :through => :team_members
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def captain
    team_members.find(:first, :conditions => {:state => 'captain'}).participation.participant
  end
end
