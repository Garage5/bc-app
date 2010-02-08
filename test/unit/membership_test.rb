require 'test_helper'

class MembershipTest < ActiveSupport::TestCase
  should_belong_to :team
  should_belong_to :member
  should_belong_to :tournament
  
  # should_validate_uniqueness_of :member_id, :scoped_to => :tournament_id
  
  should_have_db_column  :captain, :type => 'boolean', :default => false
  should_have_db_columns :team_id, :member_id
  
  context 'A Membership' do
    setup do 
      @user = Factory(:user)
      @team = Team.create :name => 'Navi', :captain => User.first, :tournament_id => 1
    end

    should 'have a tournament_id when created' do
      assert_not_nil @team.memberships.first.tournament_id
    end
  end
end
