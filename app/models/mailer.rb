class Mailer < ActionMailer::Base
  

  def team_invitation(sent_at = Time.now)
    subject    'Mailer#team_invitation'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
