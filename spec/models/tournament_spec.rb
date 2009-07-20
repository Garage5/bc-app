require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tournament do
  before(:each) do
    @tournament = Factory(:tournament)
  end
  
  it "should not be able to be started once already started" do
    4.times do
      u = Factory(:user)
      u.join_tournament(@tournament).accept!
    end
    @tournament.start
    @tournament.start
    @tournament.errors.size.should == 1
  end
  
  it "should not be able to be started if there are no participants" do
    @tournament.start
    @tournament.errors.size.should == 1
    @tournament.started?.should be_false
  end
  
  it "should convert 8 man to 4 man if less then 4 participants" do
    pending
    4.times do
      u = Factory(:user)
      u.join_tournament(@tournament).accept!
    end
    @tournament.start
    @tournament.reload
    @tournament.slot_count.should == 4
    @tournament.matches(:round => 1).count.should == 2
  end
  
  it "should create matches based on number of participants" do
    4.times do
      u = Factory(:user)
      u.join_tournament(@tournament).accept!
    end
    
    lambda do
      @tournament.start
    end.should change{@tournament.matches(:round => 1).count}.from(0).to(2)
  end
  
  it "should create matches when started" do
    8.times do
      u = Factory(:user)
      u.join_tournament(@tournament).accept!
    end
    
    lambda do
      @tournament.start
    end.should change{@tournament.matches.for_round(1).count}.from(0).to(4)
  end
  
  it "should have participants in a match" do
    8.times do
      u = Factory(:user)
      u.join_tournament(@tournament).accept!
    end
    @tournament.start
    match = @tournament.matches.for_round(1).first
    match.player_one.should_not be_nil
    match.player_one.should_not be_nil
  end
  
  it "should have different participants in a match" do
    8.times do
      u = Factory(:user)
      u.join_tournament(@tournament).accept!
    end
    @tournament.start
    match = @tournament.matches.for_round(1).first
    match.player_one.should_not == match.player_two
  end
end
