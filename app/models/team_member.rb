class TeamMember < ActiveRecord::Base
  named_scope :for_tournament, lambda {|tournament| {:conditions => {:tournament_id => tournament.id}}}
  named_scope :pending, :conditions => ['state = ?', 'pending']
  
  validate :max_players_per_team, :on => :create

  belongs_to :tournament
  belongs_to :team
  belongs_to :member, :class_name => 'User'
  
  def max_players_per_team
    if @team.members.count >= self.tournament.players_per_team
      self.errors.add_to_base("You can only have #{self.tournament.players_per_team} player per team for this tournament.")
    end if @team
  end
  
  def before_create
    self.tournament_id = self.team.tournament_id
  end
  
  def before_destroy
    if self.tournament.started?
      self.errors.add_to_base('You cannot remove team members once the tournament has started.')
    end
  end
  
  def after_create
    # if self.state == 'pending'
    #   Mailer.deliver_team_invitation(self)
    # end
  end
  
  def after_destroy
    if self.state == 'captain'
      t = Team.find(team_id)
      t.destroy if t
    end
  end
  
  def accept!
    unless self.state == 'captain'
      self.update_attributes(:state => 'active')
      self.member.team_members.pending.for_tournament(self.tournament).each do |invite|
        invite.destroy
      end
    end
  end
  
end
