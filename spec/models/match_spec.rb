require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Match do
  
  before(:each) do
    @tournament = Factory(:tournament)
    8.times do
      Factory(:user).join_tournament(@tournament).accept!
    end
    @tournament.start
  end
  
  it "should get the position of child match" do
    match = @tournament.rounds.first.matches[1].find_child_match_position.should == 1
  end
  
  it "should advance 1st player of 2nd match to 2nd slot in 1st match in the next round" do
    match = @tournament.rounds.first.matches[1]
    match.advance(:player_one)
    @tournament.rounds[1].matches.first.player_two.should == match.player_one
  end
  
  it "should advance 2st player of 3nd match to 1nd slot in 2st match in the next round" do
    match = @tournament.rounds.first.matches[2]
    match.advance(:player_two)
    @tournament.rounds[1].matches[1].player_one.should == match.player_two
  end
  
  it "should advance winner to next round when both players are in agreement" do
    @tournament.start
    match = @tournament.rounds.first.matches.first
    match.submit_results(:player_one, :won)
    match.submit_results(:player_two, :lost)
    match.winner.should == match.player_one
    match.child_match_in_next_round.player_one.should == match.player_one
  end

end
