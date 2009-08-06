require File.dirname(__FILE__) + '/../spec_helper'

describe Participation do
  before(:each) do
    @tournament = Factory(:tournament)
    @host, @user = Factory(:user), Factory(:user)
  end
  
  describe User do
    it "should have non-active participants" do
      @user.join_tournament @tournament
      @tournament.active_participants.should == []
      @tournament.pending_participants.should == [@user]
    end

    it "should accept a participant" do
      @user.join_tournament @tournament
      p = Participation.find_by_participant_id_and_tournament_id(@user.id, @tournament.id)
      p.accept!
      @tournament.active_participants.should == [@user]
      @tournament.pending_participants.should == []
    end

    it "should add a co-host" do
      @user.cohost_tournament(@tournament)
      @tournament.cohosts.should == [@user]
    end
    
    it "should not be able to participate in a tournament he/she is hosting"
  end

end
