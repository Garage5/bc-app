class TeamMember < ActiveRecord::Base
  belongs_to :team
  belongs_to :participation
  
  def after_create
    if self.state == 'pending'
      Mailer.deliver_team_invitation(self)
    end
  end
  
  def after_destroy
    if self.state == 'captain'
      t = Team.find(team_id)
      t.destroy if t
    end
  end
end
