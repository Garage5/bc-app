class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :participations, :foreign_key => :participant_id, :dependent => :destroy
  has_many :tournaments, :through => :participations
  
  validates_acceptance_of :terms_of_service, :on => :create
  validates_length_of :login, :within => 3..13
  
  def join_tournament(tournament)
    Participation.create(:participant => self, :tournament => tournament)
  end
  
  def cohost_tournament(tournament)
    Participation.create(:participant => self, :tournament => tournament, :state => 'cohost')
  end
  
  def is_hosting?(tournament)
    tournament.instance.host_id == self.id || Participation.exists?(:participant_id => self.id, :tournament_id => tournament.id, :state => 'cohost')
  end
  
  def is_participant_of?(tournament)
    Participation.exists?(:participant_id => self.id, :tournament_id => tournament.id, :state => ['pending', 'active'])
  end
  
  def is_eligible_to_join?(tournament)
    !self.is_hosting?(tournament) && !self.is_participant_of?(tournament)
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
  
  def role_in(tournament, team)
    return "Host" if tournament.instance.host == self
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
  def join_team(team)
    part = Participation.find(:first, :conditions => {:participant_id => self.id, :tournament_id => team.tournament.id, :state => 'active'}, :include => [:team_memberships])
    # uses reject instead of find with conditions to benefit from query cache
    part.team_memberships.each do |memb|
      memb.team == team ? memb.update_attribute(:state, 'active') : memb.destroy
    end
  end
  
  def decline_team(team)
    part = Participation.find(:first, :conditions => {:participant_id => self.id, :tournament_id => team.tournament.id, :state => 'active'}, :include => [:team_memberships])
    memb = part.team_memberships.find(:first, :conditions => {:team_id => team.id})
    memb.destroy
  end
  
end
