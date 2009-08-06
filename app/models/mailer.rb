class Mailer < ActionMailer::Base
  

  def team_invitation(team_membership, sent_at = Time.now)
    subject    '[TBC] Team Invitation'
    recipients team_membership.participation.participant.email
    from       '"The Battle Center" <no-reply@thebattlebegins.com>'
    sent_on    sent_at
    
    body       :team_membership => team_membership
  end

end
