require File.dirname(__FILE__) + '/../spec_helper'

describe Team do
  before(:each) do
    @tournament = Factory(:tournament, :use_teams => true)
    8.times do
      u = Factory(:user)
      u.join_tournament(@tournament).accept!
    end
    @participants = @tournament.participants
  end
  
  describe 'user' do
    
    # it "should not be able to join a team if already in a team" do
    #   captain = @participants.shift
    #   team = @tournament.create_team(captain, @participants)
    #   users[0].join_team(team).should be_false
    #   users[0].errors.size.should == 1
    # end
    # 
    # it "should not be able to join a team if user is not tournament participant" do
    #   player = @participants.first
    #   
    #   captain = @participants.shift
    #   team = @tournament.create_team(captain, @participants)
    # end
    
    it "should not be able to create a team if already in a team"
    
    it "should not be able to create a team if user is an official"
    
    it "should not be able to create a team if tournament isnt team based"
    
  end

  it "should not allow more than max players per team"
end
