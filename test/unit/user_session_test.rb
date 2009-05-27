require 'test_helper'

class UserSessionTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert UserSession.new.valid?
  end
end
