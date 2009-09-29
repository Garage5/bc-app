require File.dirname(__FILE__) + '/../spec_helper'

describe Team do
  before(:each) do
    @host = Factory(:user)
    @tournament = Factory(:tournament, :host => @host, :players_per_team => 2)
    16.times do
      u = Factory(:user)
      u.join_tournament(@tournament).accept!
    end
    @participants = @tournament.participants
  end
  
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
  
  describe 'A team based tournament' do
    before(:each) do
      @tournament.update_attributes(:use_teams => true)
      4.times do |i|
        t = @tournament.teams.create(:name => "#{i}-team", :captain => @participants.shift)
        t.members << @participants.shift
      end
    end
    
    it "should accept a team invitation" do
      user = @participants.all[1]
      invite = user.team_members.for_tournament(@tournament).first
      lambda {
        invite.accept!
      }.should change{invite.team.members.count}.from(0).to(1)
    end
    
    it "should not allow members to be removed once tournament has started" do
      TeamMember.all.each {|t| t.accept!}
      @tournament.start
      @tournament.reload
      team = @tournament.teams.first
      membership = team.team_members.first(:conditions => {:member_id => team.members.first})
      membership.destroy
      membership.errors.should_not be_empty
    end
  
    it "should not be editable once tournament has started" do
      @tournament.start
      @tournament.reload
      team = @tournament.teams.first
      team.update_attributes(:name => 'blah')
      team.errors.should_not be_empty
    end
  
    it "should cap number of teams based on max slots" do
      @tournament.update_attributes(:slot_count => 4)
      captain = @tournament.participants.last
      team = @tournament.teams.create(:name => 'blah', :captain => captain)
      team.errors.should_not be_empty
    end
  
    it "should cap number of players per team" do
      TeamMember.all.each {|t| t.accept!}
      invite = @tournament.teams.first.members << User.last
      invite = @tournament.team_members.create(:team => @tournament.teams.first, :member => User.last)
      invite.errors.should_not be_empty
    end
  
    it "should not be able to create a team if already in a team" do
      TeamMember.all.each {|t| t.accept!}
      captain = @tournament.teams.first.members.first
      team = @tournament.teams.create(:name => 'blah', :captain => captain)
      team.errors.should_not be_empty
    end
  
    it "should not be able to create a team if user is an official" do
      captain = @tournament.host
      team = @tournament.teams.create(:name => 'blah', :captain => captain)
      team.errors.should_not be_empty
    end
  
    it "should destroy pending invitations once user accepts" do
      @tournament.reload
      user = @tournament.participants[1]
      Team.last.members << user
      lambda {
        user.team_members.pending.for_tournament(@tournament).first.accept!
      }.should change{user.team_members.pending.for_tournament(@tournament).count}.from(2).to(0)
    end
    
    it "should destroy pending invitations if user creates own team" do
      @tournament.reload
      user = @tournament.participants[1]
      Team.last.members << user
      lambda {
        user.team_members.pending.for_tournament(@tournament).first.accept!
      }.should change{user.team_members.pending.for_tournament(@tournament).count}.from(2).to(0)
    end
  end
  
  it "should not be able to create a team if tournament isnt team based" do
    captain = @participants.first
    team = @tournament.teams.create(:name => 'blah', :captain => captain)
    team.errors.should_not be_empty
  end

end
