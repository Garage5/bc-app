class Mailer < ActionMailer::Base
  

  def team_invitation(team_membership, sent_at = Time.now)
    subject    '[TBC] Team Invitation'
    recipients team_membership.participation.participant.email
    from       'no-reply@thebattlebegins.com'
    # headers    'From' => '"The Battle Center" <no-reply@thebattlebegins.com>'
    sent_on    sent_at
    
    body       :team_membership => team_membership
  end

  def message_subscription(message, user, sent_at = Time.now)
    subject    '[TBC] Message Subscription'
    recipients user.email
    from       'no-reply@thebattlebegins.com'
    # headers    'From' => '"The Battle Center" <no-reply@thebattlebegins.com>'
    sent_on    sent_at
    
    body       :message => message, :user => user
  end

end
