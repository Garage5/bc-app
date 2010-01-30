class User < ActiveRecord::Base
  devise :authenticatable, :recoverable, :rememberable, :trackable, :validatable
  
  #acts_as_authentic do |c|
  #  c.validates_length_of_password_field_options = {:minimum => 7}
  #end
  
  has_many :accounts
  has_many :participations, :foreign_key => :participant_id, :dependent => :destroy
  has_many :tournaments, :through => :participations
  has_many :team_members, :foreign_key => :member_id
  has_many :teams, :through => :team_members
  
  validates_acceptance_of :terms_of_service, :on => :create
  validates_length_of :username, :within => 4..13
  validates_presence_of :username
  
  attr_accessible :username, :email, :password, :password_confirmation
  
  has_attached_file :avatar, :styles => {:large => "75x75#", :medium => "48x48#", :small => "32x32#"},
    :default_url => "/:class/:attachment/missing_:style.jpg",
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    :bucket => 'tbbdev',
    :path => ":attachment/:id/:style.:extension"
  
  def login
    username
  end
  
  def to_param
    self.username
  end
  
  def first_name
    name.split(' ')[0] rescue login
  end

  def last_activity
    self[:last_activity].try(:iso8601) || 'never'
  end
  
  def join_tournament(tournament)
    Participation.create(:participant => self, :tournament => tournament)
  end
  
  def cohost_tournament(tournament)
    Participation.create(:participant => self, :tournament => tournament, :state => 'cohost')
  end
  
  def is_hosting?(account)
    account.admin_id == self.id
  end
  
  def is_cohosting?(tournament)
    self.is_hosting?(tournament.account) || Participation.exists?(:participant_id => self.id, :tournament_id => tournament.id, :state => 'cohost')
  end
  
  def is_participant_of?(tournament)
    Participation.exists?(['participant_id = ? AND tournament_id = ? AND accepted_at IS NOT NULL', self.id, tournament.id])
  end
  
  def is_eligible_to_join?(tournament)
    participation = Participation.exists?(
      :participant_id => self.id, 
      :tournament_id => tournament.id, 
      :state => ['active', 'pending']
    )
    !self.is_hosting?(tournament.account) && !participation
  end
  
  def team_memberships_in(tournament, include_pending = false)
    states = ['active', 'captain']
    states << 'pending' if include_pending
    part = Participation.find(:first, :conditions => {:participant_id => self.id, :tournament_id => tournament.id, :state => 'active'}, :include => [:team_memberships])
    return [] unless part
    # uses reject instead of find with conditions to benefit from query cache
    part.team_memberships.find(:all).reject { |m| !states.include?(m.state)}
  end
  
  def teams_in(tournament, include_pending = false)
    r = []
    team_memberships_in(tournament, include_pending).each do |memb|
      r << memb.team
    end
    r
  end
  
  def member_of?(team, include_pending = false)
    teams_in(team.tournament, include_pending).include?(team)
  end
 
  def has_team?(tournament)
    tournament.team_members.exists?(:member_id => self.id)
  end
  
  def is_captain?(tournament)
    tournament.team_members.exists?(:member_id => self.id, :state => 'captain')
  end
  
  def role_in(tournament, team)
    return "Host" if tournament.account.admin_id == self.id
    return "Co-Host" if is_hosting?(tournament)
    return nil unless team
    part = participations.find(:first, :conditions => {:tournament_id => team.tournament_id})
    return nil unless part
    membs = part.team_memberships.find(:first, :conditions => {:team_id => team.id})
    return nil unless membs
    return "Captain" if membs.state == 'captain'
    return "Member" if membs.state == 'active'
    return "Invited" if membs.state == 'pending'
  end
  
  # accept invitation that already exists
  def join_team(team, tournament)
    invite = self.team_members.pending(:conditions => {:team => team}).for_tournament(tournament).first
    invite.accept!
    # part = Participation.find(:first, :conditions => {:participant_id => self.id, :tournament_id => team.tournament.id, :state => 'active'}, :include => [:team_memberships])
    # uses reject instead of find with conditions to benefit from query cache
    # part.team_memberships.each do |memb|
    #  memb.team == team ? memb.update_attribute(:state, 'active') : memb.destroy
    # end
  end
  
  def decline_team(team)
    part = Participation.find(:first, :conditions => {:participant_id => self.id, :tournament_id => team.tournament.id, :state => 'active'}, :include => [:team_memberships])
    memb = part.team_memberships.find(:first, :conditions => {:team_id => team.id})
    memb.destroy
  end
  
end
