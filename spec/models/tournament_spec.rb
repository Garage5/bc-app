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
    @tournament.rounds.by_number(2).first.matches.count.should == 2
    @tournament.rounds.by_number(3).first.matches.count.should == 1
  end
  
  it "should have participants in a match" do
    @tournament.start
    match = @tournament.rounds.first.matches.first
    match.players[0].should_not be_nil
    match.players[1].should_not be_nil
  end
  
  it "should have different participants in a match" do
    @tournament.start
    match = @tournament.rounds.first.matches.first
    match.players[0].should_not == match.players[1]
  end
  
  it "should generate bye slots for empty slots when started" do
    3.times { @tournament.participations.first.destroy }
    @tournament.start
    @tournament.matches.[0].slots[1].bye?.should be_true
    @tournament.matches.[1].slots[1].bye?.should be_true
    @tournament.matches.[2].slots[1].bye?.should be_true        
  end
  
  it "should generate bye slot for slot who's parent match consists of 2 byes"

  it "should auto advance slot to non bye slot"

end
