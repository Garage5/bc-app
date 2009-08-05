require 'test_helper'

class MailerTest < ActionMailer::TestCase
  test "team_invitation" do
    @expected.subject = 'Mailer#team_invitation'
    @expected.body    = read_fixture('team_invitation')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Mailer.create_team_invitation(@expected.date).encoded
  end

end
