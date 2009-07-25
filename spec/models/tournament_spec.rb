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
    @tournament.rounds.first.matches.count.should == 2
  end
  
  it "should create rounds when started" do
    lambda do
      @tournament.start
    end.should change{@tournament.rounds.count}.from(0).to(3)
  end
  
  it "should create round matches when started" do
    @tournament.start
    @tournament.rounds.by_number(1).first.matches.count.should == 4
    @tournament.rounds.by_number(2).first.matches.count.should == 2
    @tournament.rounds.by_number(3).first.matches.count.should == 1
  end
  
  it "should have participants in a match" do
    @tournament.start
    match = @tournament.rounds.first.matches.first
    match.player_one.should_not be_nil
    match.player_one.should_not be_nil
  end
  
  it "should have different participants in a match" do
    @tournament.start
    match = @tournament.rounds.first.matches.first
    match.player_one.should_not == match.player_two
  end
  
  it "should advance winner to next round when both players are in agreement" do
    @tournament.start
    match = @tournament.rounds.first.matches.first
    match.submit_results()
  end
end
