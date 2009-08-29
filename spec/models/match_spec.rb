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
    match = @tournament.rounds.first.matches[0]
    match.next.should_not be_nil
    match.next.should == @tournament.rounds[1].matches[0]
  end
  
  it "should get previous slot" do
    match = @tournament.rounds.first.matches[0]
    match.slots[0].advance!
    match.next.slots[0].previous.should == match.slots[0]
  end
  
  it "shoulc get previous match for slot" do
    match = @tournament.rounds.first.matches[0]
    match.next.slots[0].parent_match.should == match
  end
  
  it "should advance 1st player of 2nd match to 2nd slot in 1st match in the next round" do
    match = @tournament.rounds.first.matches[1]
    match.slots[0].advance!
    match.next.slots[1].player.should == match.slots[0].player
  end
  
  it "should advance 2nd player of 3nd match to 1st slot in 2nd match in the next round" do
    match = @tournament.rounds.first.matches[2]
    match.slots[1].advance!
    match.next.slots[0].player.should == match.slots[1].player
  end
  
  it "should advance winner to next round when both players are in agreement" do
    match = @tournament.rounds.first.matches.first
    match.slots[0].won!
    match.slots[1].lost!
    match.reload
    match.winner.should == match.slots[0].player
    match.next.slots[0].player.should == match.slots[0].player
  end
  
  it "should dispute the match when both players claim they won" do
    match = @tournament.rounds.first.matches.first
    match.slots[0].won!
    match.slots[1].won!
    match.reload
    match.status.should == 'disputed'
  end
  
  it "should dispute the match when both players claim they lost" do
    match = @tournament.rounds.first.matches.first
    match.slots[0].lost!
    match.slots[1].lost!
    match.reload
    match.status.should == 'disputed'
  end
  
  it "should disqualify a player" do
    match = @tournament.rounds.first.matches.first
    match.slots[1].disqualify!
    match.slots[1].status.should == 'disqualified'
  end
  
  it "should advance opponent when slot is disqualified" do
    match = @tournament.rounds.first.matches.first
    match.slots[1].disqualify!
    match.reload
    match.winner.should == match.slots[0].player
    match.next.slots[0].player.should == match.slots[0].player
  end
  
  it "should remove player from match when reverted" do
    match = @tournament.rounds.first.matches.first
    match.slots[1].advance!
    match.next.slots[0].revert!
    match.next.slots[0].player.should be_nil
  end
  
  it "should nullify winner of previous match when slot is reverted" do
    match = @tournament.rounds.first.matches.first
    match.slots[1].advance!
    match.next.slots[0].revert!
    match.reload
    match.winner.should be_nil
  end
  
  it "should not allow slots to be reverted more than once" do
    match1 = @tournament.rounds.first.matches.first
    match2 = @tournament.rounds.first.matches[1]
    match3 = @tournament.rounds.first.matches[2]
    match4 = @tournament.rounds.first.matches[3]
    
    [match1, match2, match3, match4].each {|m| m.slots[1].advance!}
    
    match1.next.slots[0].advance!
    match1.next.next.slots[0].revert!

    match1.next.slots[0].can_revert?.should be_false
    match1.next.slots[0].revert!.should be_false
  end
  
  it "should make winner of last match winner of tournament" do
    @tournament.rounds.each do |r|
      r.matches.each do |m|
        m.slots[0].advance!
      end unless r == @tournament.rounds.last
    end
    match = @tournament.rounds.last.matches.first
    match.slots[0].advance!
    @tournament.reload
    @tournament.places[0].id.should == match.slots[0].player.id
  end
  
  describe 'events' do
    it "should create an event when a slot is disqualified" do
      match = @tournament.rounds.first.matches.first
      match.slots[1].disqualify!
      # should be second to last event since disqualifying a player auto advances it's opponent
      @tournament.events[1].message.should == "#{match.slots[1].player.login} has been disqualified"
    end
    
    it "should create an event when a match is won" do
      match = @tournament.rounds.first.matches.first
      match.slots[0].lost!
      match.slots[1].won!
      @tournament.events.first.message.should == "#{match.slots[1].player.login} vanquished #{match.slots[0].player.login} in round #{match.round.number}"
    end
    
    it "should create an event when a match is disputed" do
      match = @tournament.rounds.first.matches.first
      match.slots[0].won!
      match.slots[1].won!
      @tournament.events.first.message.should == "A dispute has occured between #{match.slots[0].player.login} and #{match.slots[1].player.login}"
    end
    
    it "should create an event when the tournament has a winner" do
      pending
      @tournament.rounds.each do |r|
        r.matches.each do |m|
          m.slots[0].advance!
        end unless r == @tournament.rounds.last
      end
      match = @tournament.rounds.last.matches.first
      match.slots[0].advance!
      @tournament.events.first.message.should == ""
    end
  end
  
  it "should not be active if match has less than 2 players" do
    match = @tournament.rounds.first.matches.first
    match.slots[0].advance!
    match.next.active?.should be_false
  end
  
  it "should delete associated models when a player is disqualified or reverted"
  
  it "should delete associated 'won' events when a player is disqualified"
  
  describe 'byes' do
        
    it "should not be able to be reverted if byed to corrent slot"
    
  end
  
  describe 'slot' do
    
    it "should be a team if tournament is team based"
    
    it "should be a player if tournament is not team based"
    
  end

end
