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
    match.next.slot(0).should == match.slot(0)
  end
  
  it "should advance 2nd player of 3nd match to 1nd slot in 2nd match in the next round" do
    match = @tournament.rounds.first.matches[2]
    match.slot(1).advance!
    match.next.slot(0).should == match.slot(1)
  end
  
  it "should advance winner to next round when both players are in agreement" do
    match = @tournament.rounds.first.matches.first
    match.slot(0).won!
    match.slot(1).lost!
    match.winner.should == match.slot(0)
    match.next.slot(0).should == match.slot(1)
  end
  
  it "should disqualify a player" do
    match = @tournament.rounds.first.matches.first
    match.slot(1).disqualify!
    match.slot(1).status.should == 'disqualified'
    match.winner.should == match.slot(0)
  end
  
  it "should advance opponent when slot is disqualified" do
    match = @tournament.rounds.first.matches.first
    match.slot(1).disqualify!
    match.winner.should == match.slot(0)
    match.next.slot(0).should == match.slot(0)
  end
  
  it "should remove player from match when reverted" do
    match = @tournament.rounds.first.matches.first
    match.slot(1).advance
    match.next.slot(0).revert!
    match.next.slot(0).should be_nil
  end
  
  it "should nullify winner of previous match when slot is reverted" do
    match = @tournament.rounds.first.matches.first
    match.slot(1).advance
    match.next.slot(0).revert!
    match.winner.should be_nil
  end
  
  it "should make winner of last match winner of tournament" do
    @tournament.rounds.each do |r|
      r.matches.each do |m|
        m.slot(0).advance!
      end unless r == @tournamnet.rounds.last
    end
    match = @tournament.rounds.last.matches.first
    match.slot(0).advance!
    @tournament.winner.should == match.slot(0)
  end
  
  describe Slot do
    
    it "should be a team if tournament is team based"
    
    it "should be a player if tournament is not team based"
    
  end

end
