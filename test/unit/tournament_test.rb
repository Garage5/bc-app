require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  setup do
    @tournament = Factory(:tournament, :use_teams => true)
  end

  # should 'have active members when team accepted' do
  #   @user = Factory(:user)
  #   @team = Team.create :name => 'Navi', :captain => User.first, :tournament_id => 1
  #   
  #   assert_difference 'Tournament.find(2).memberships.count', 1 do
  #     @team.accept! 
  #   end
  # end

end
