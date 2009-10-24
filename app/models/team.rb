class Team < ActiveRecord::Base
  belongs_to :tournament
  
  has_many :team_members, :dependent => :destroy
  has_many :members, :through => :team_members, :conditions => {:team_members => {:state => 'active'}}
  has_one  :captain, :through => :team_members, :conditions => ['state = ?', 'captain'], :source => :member
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  validate_on_update :tournament_not_started
  validate_on_create :user_not_in_team
  validate_on_create :user_not_official
  validate_on_create :tournament_is_team_based
  validate_on_create :tournament_has_open_slots
  
  def login
    # login attribute for brackets
    name
  end
  
  # def captain
  #   team_members.find(:first, :conditions => {:state => 'captain'}).participation.participant
  # end
  
  def remove_member(member)
    self.team_members.first(:conditions => {:member_id => member}).destroy
  end
  
  def captain=(user)
    self.team_members.build(:member => user, :state => 'captain')
    @captain = user
  end
  
  def invite(user)
    unless self.team_members.exists?(:member_id => user)
      self.team_members.create(:member => user)
    else
      self.errors.add_to_base('User has already been invited to this team.')
    end
  end
  
  def tournament_has_open_slots
    errors.add_to_base('The maximum number of teams for the tournament has been reached.') unless @tournament.teams.count < @tournament.slot_count
  end
  
  def restricted_names
    errors.add(:name, 'is not allowed') if ['Participants', 'Officials', 'Pending Approval'].include?(name.strip)
  end
  
  def tournament_not_started
    errors.add_to_base('You cannot edit a team once the tournament has started.') if self.tournament.started?
  end
  
  def user_not_in_team
    errors.add_to_base('You are already in a team.') if @captain.has_team?(self.tournament)
  end
  
  def user_not_official
    errors.add_to_base('You cannot create a team if you are a tournament official.') if @tournament.officials.include?(@captain)
  end
  
  def tournament_is_team_based
    errors.add_to_base('This tournament is not team based.') if !@tournament.use_teams?
  end
end
