require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  should_belong_to :tournament
  should_belong_to :captain
  should_have_many :memberships, :dependent => :destroy
  
  should_have_many :members, :through => :memberships
  should_validate_presence_of :name
  
  should_have_db_columns :name, :tournament_id
  
  context 'A Team' do
    setup do 
      @user = Factory(:user)
      @team = Team.create :name => 'Navi', :captain => User.first, :tournament_id => 1
    end
    
    should_create Membership
    
    should 'have a captain' do
      assert_equal Team.first.captain, User.first
      assert_equal Team.first.members.first, Team.first.captain
    end
    
    context 'when destroyed' do
      setup { @team.destroy }
      should_change('the number of teams', :by => -1) { Team.count }
      should_change('the number of memberships', :by => -1) { Membership.count }
    end
  end
end
