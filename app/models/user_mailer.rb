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


end
