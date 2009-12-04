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
    
    it "should not accept a participant if slot limit is reached" do
      @tournament.slot_count.times do
        u = Factory(:user)
        u.join_tournament @tournament
        p = Participation.find_by_participant_id_and_tournament_id(u.id, @tournament.id)
        p.accept!
      end
      
      @user.join_tournament @tournament
      p = Participation.find_by_participant_id_and_tournament_id(@user.id, @tournament.id)
      p.accept!.should be_false
    end

    it "should add a co-host" do
      @user.cohost_tournament(@tournament)
      @tournament.cohosts.should == [@user]
    end
    
    it "#officials should get  tournament host + cohosts" do
      @user.cohost_tournament(@tournament)
      @tournament.officials.should == [@tournament.instance.host, @user]
    end
    
    it "#"
    
  end

end
