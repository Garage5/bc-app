class UserMailer < ActionMailer::Base
  
  def welcome_email(user)
    recipients    user.email
    from          "The Battle Center <noreply@thebattlecenter.com>"
    subject       "Welcome to The Battle Center"
    sent_on       Time.now
    body          {:user => user, :url => "http://example.com/login"}
  end

end
