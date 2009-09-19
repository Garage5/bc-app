require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tournament do
  before(:each) do
    @tournament = Factory(:tournament)
    8.times do
      u = Factory(:user)
      u.join_tournament(@tournament).accept!
    end
  end
  
  it "should not be able to be started once already started" do
    @tournament.start
    @tournament.start
    @tournament.errors.size.should == 1
  end
  
  it "should not be able to be started if there are no participants" do
    @tournament.participations.delete_all
    @tournament.start
    @tournament.errors.size.should == 1
    @tournament.started?.should be_false
  end
  
  it "should convert 8 man to 4 man if less then 4 participants" do
    pending
    @tournament.start
    @tournament.reload
    @tournament.slot_count.should == 4
    @tournament.matches(:round => 1).count.should == 2
  end
  
  it "should create matches based on number of participants" do    
    @tournament.start
    @tournament.rounds.first.matches.count.should == 4
  end
  
  it "should create rounds when started" do
    lambda do
      @tournament.start
    end.should change{@tournament.rounds.count}.from(0).to(3)
  end
  
  it "should create round matches when started" do
    @tournament.start
    @tournament.rounds.by_number(1).first.matches.count.should == 4
  end
  
  it "should have participants in a match" do
    @tournament.start
    match = @tournament.rounds.first.matches.first
    match.slots[0].player.should_not be_nil
    match.slots[1].player.should_not be_nil
  end
  
  it "should have different participants in a match" do
    @tournament.start
    match = @tournament.rounds.first.matches.first
    match.slots[0].player.should_not == match.slots[1].player
  end
  
  it "should generate bye slots for empty slots when started" do
    3.times { @tournament.participations.first.destroy }
    @tournament.start
    @tournament.matches[0].slots[0].bye?.should be_false
    @tournament.matches[0].slots[1].bye?.should be_true
    
    @tournament.matches[1].slots[0].bye?.should be_false    
    @tournament.matches[1].slots[1].bye?.should be_true
    
    @tournament.matches[2].slots[0].bye?.should be_false
    @tournament.matches[2].slots[1].bye?.should be_true        
  end

  it "should auto advance slot to non bye slot" do
    3.times { @tournament.participations.first.destroy }
    @tournament.start
    @tournament.matches[0].slots[0].player.should == @tournament.rounds[1].matches[0].slots[0].player
    @tournament.matches[1].slots[0].player.should == @tournament.rounds[1].matches[0].slots[1].player
    @tournament.matches[2].slots[0].player.should == @tournament.rounds[1].matches[1].slots[0].player
  end
  
  it "should not let slots be reverted to byed match" do
    3.times { @tournament.participations.first.destroy }
    @tournament.start
    @tournament.rounds[1].matches[0].slots[0].revert!.should be_false
  end
  
  describe "Team based" do
    before(:each) do
      @tournament.update_attributes(:use_teams => true)
    end
    it "should not be able to be started if there are no teams" do
      @tournament.start
      @tournament.errors.size.should == 1
      @tournament.started?.should be_false
    end
    
    it "should have a captain" do
      team = @tournament.teams.new(:name => 'Cool People', :captain => User.first)
      team.save
      team.captain.should == User.first
    end
    
    it "should start a tournament" do
      participants = @tournament.participants
      4.times do 
        team = Factory(:team, :captain => participants.shift, :tournament => @tournament)
        team.members << participants.shift
      end
      @tournament.start
      @tournament.errors.should be_empty
      @tournament.started?.should be_true
    end
    
    it "should have slots that are teams" do
      participants = @tournament.participants
      4.times do 
        team = Factory(:team, :captain => participants.shift, :tournament => @tournament)
        team.members << participants.shift
      end
      @tournament.start
      @tournament.matches.first.slots[0].player.class.should == Team
    end
  end
end
