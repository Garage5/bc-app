require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  should_belong_to :tournament
  should_belong_to :captain
  # should_have_many :memberships, :dependent => :destroy
  
  # should_have_many :members, :through => :memberships
  should_validate_presence_of :name
  # 
  should_have_db_columns :name, :tournament_id
  # 
  context 'A Team' do
    setup do
      @tournament = Factory(:tournament, :use_teams => true)
      @user = User.find_by_username('bryan')
      @team = Team.new :name => 'Navi', :captain => @user, :tournament_id => @tournament.id, :battleids =>  ['matt', 'james']
    end
        
    should 'validate that battleids are unique' do
      @team.battleids = ['matt', 'matt', 'james']
      @team.save
      assert_equal @team.valid?, false
      assert @team.errors.full_messages.include?('BattleIDs must be unique')
    end
    
    should 'validate that users are not already in tournament' do
      @team.save
      
      @team2 = Team.new :name => 'RDA', :captain => User.find_by_username('victor'), :tournament_id => @tournament.id
      @team2.battleids = ['matt', 'james']
      assert_equal @team2.valid?, false
      
      assert @team2.errors.full_messages.include?("matt is already participating in this tournament")
    end
    
    context 'when saved' do
      setup do
        @team.save
      end
      
      should_change('the number of memberships', :by => 3) { Membership.count }

      should 'not be accepted' do
        assert_nil @team.accepted_at
      end

      should 'be accepted' do
        assert_difference "Participation.accepted.count", 1 do
          @team.accept!
        end
      end

      should 'have a captain' do
        assert_equal Team.first.captain, @user
        assert_equal Team.first.members.first, Team.first.captain
      end
      
      context 'when destroyed' do
        setup { @team.destroy }
        should_change('the number of teams', :by => -1) { Team.count }
        should_change('the number of memberships', :by => -3) { Membership.count }
      end
    end
    
  end
end
