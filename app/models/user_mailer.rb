class UserMailer < ActionMailer::Base
  
  def setup_email(to, subject, from = AppConfig['from_email'])
    @sent_on = Time.now
    @subject = subject
    @recipients = to.respond_to?(:email) ? to.email : to
    @from = from.respond_to?(:email) ? from.email : from
  end
  
  def welcome_email(user)
    setup_email(user, "Your BattleID")
    @body = { :user => user }
  end
  
  def joined_tournament_email(user, tournament)
    setup_email(user, "You have applied to participate in #{tournament.name}")
    @body = {:user => user, :tournament => tournament}
  end
  
  def accepted_to_tournament_email(user, tournament)
    setup_email(user, "You have been accepted to participate in #{tournament.name}")
    @body = {:user => user, :tournament => tournament}
  end
  
  def invited_to_cohost_email(user, tournament)
    setup_email(user, "You have been invited to cohost #{tournament.name}")
    @body = {:user => user, :tournament => tournament}
  end

end
