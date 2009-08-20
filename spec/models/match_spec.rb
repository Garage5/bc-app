require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Match do
  
  before(:each) do
    @tournament = Factory(:tournament)
    8.times do
      Factory(:user).join_tournament(@tournament).accept!
    end
    @tournament.start
  end
  
  it "should get next match" do
    match = @tournament.rounds.first.matches[1]
    match.next.should == @tournament.rounds[2].matches[1]
  end
  
  it "should advance 1st player of 2nd match to 2nd slot in 1st match in the next round" do
    match = @tournament.rounds.first.matches[1]
    match.slot(0).advance!
    match.next.slot_two.should == match.slot_one
  end
  
  it "should advance 2nd player of 3nd match to 1nd slot in 2nd match in the next round" do
    match = @tournament.rounds.first.matches[2]
    match.slot(1).advance!
    match.next.slot_one.should == match.slot_two
  end
  
  it "should advance winner to next round when both players are in agreement" do
    @tournament.start
    match = @tournament.rounds.first.matches.first
    match.slot(0).won!
    match.slot(1).lost!
    match.winner.should == match.slot(0)
    match.next.slot(0).should == match.slot(1)
  end
  
  it "should disqualify a slot"
  
  it "should advance opponent when slot is disqualified"
  
  it "should revert a slot to previous match"
  
  it "should nullify winner of previews match when slot is reverted"
  
  describe Slot do
    
    it "should be a team if tournament is team based"
    
    it "should be a player if tournament is not team based"
    
  end

end
