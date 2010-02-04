require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  should_belong_to :team
  should_belong_to :member
  
  # should_validate_uniqueness_of :member_id, :scoped_to => :tournament_id
  
  should_have_db_column  :captain, :type => 'boolean', :default => false
  should_have_db_columns :team_id, :member_id
end
