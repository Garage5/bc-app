require 'test_helper'

class ParticipationsControllerTest < ActionController::TestCase    
  context "A Host" do
    setup do
      sign_in Account.first.admin
    end
    # host joining the tournament
    context "on POST to :create" do
      should_respond_with :unauthorized
      should_set_flash_to "You do not have permission to do that"
      should_not_change "the number of participants" { @tournament.participants.count }
    end
    
    # host adding a cohost
    context "on POST to :add_cohost" do
      should_respond_with :success
      should_create Participation
      should_change("the number of cohosts", :by => 1) { @tournament.cohosts.count }
    end
    
    # host removing a participant
    context "on DELETE to :deny" do
      should_respond_with :success
      should_destroy Participation
      should_change("the number of participants", :by => -1) { @tournament.participants.count } 
    end

    # host removing a participant when the tournament has started
    context "on DELETE to :deny when tournament started" do
      should_respond_with :unauthorized
      should_set_flash_to "You do not have permission to do that"
      should_not_change("the number of participants") { @tournament.participants.count }
    end
  end
  
  context "A Cohost" do
    setup do
      sign_in Tournament.first.cohosts.first
    end
    # cohost joining the tournament
    context "on POST to :create" do
      should_respond_with :unauthorized
      should_not_change("the number of participants") { @tournament.participants.count }
    end
    
    # cohost adding another cohost
    context "on POST to :add_cohost" do
      should_respond_with :unauthorized
      should_not_change("the number of cohosts") { @tournament.cohosts.count }
    end
    
    # cohost removing participation
    context "on DELETE to :deny" do
      should_respond_wtih :success
      should_destroy Participation
      should_change("the number of participants", :by => -1) { @tournament.participants.count }
    end
    
    # cohost removing other cohost
    context "on DELETE to :deny for other cohost" do
      should_respond_with :unauthorized
      should_not_change("the number of cohosts") { @tournament.cohosts.count }
    end
    
    # cohost removing participant when tournament started
    context "on DELETE to :deny when tournament started" do
      should_respond_with :unauthorized
      should_not_change("the number of participants") { @tournament.participants.count }
    end
  end
  
  context "A Participant" do
    setup do
      sign_in Tournament.first.participants.first
    end
    
    # participant joing tournament twice
    context "on POST to :create" do
      should_respond_with :unauthorized
      should_not_change("the number of pending participants") { @tournament.pending_participants.count }
    end
    
    # participant adding a cohost
    context "on POST to :add_cohost" do
      should_respond_with :unauthorized
      should_not_change("the number of cohosts") { @tournament.cohosts.count }
    end
    
    # participant removing other participant
    context "on DELETE to :deny for not own participation" do
      should_respond_with :unauthorized
      should_not_change("the number of participants") { @tournament.participants.count }
    end
    
    # participant removing self
    context "on DELETE to :deny for own participation" do
      should_respond_with :success
      should_destroy Participation
      should_change("the number of participants", :by => -1) { @tournament.participants.count }
      should "not be a participant anymore" do
        assert !@tournament.participants.include?(@user)
      end
    end
    
    # participant removing self when tournament started
    context "on DELETE to :deny for own participation when tournament started" do
      should_respond_with :unauthorized
      should_not_change("the number of participants") { @tournament.participants.count }
      should "still be a participant" do
        assert_equal @tournament.participants.find_by_user_id(@user.id).count, 1
      end
    end
  end
  
  context "A Non-participant" do
    setup do
      ids = Tournament.participants.map(&:id) + Tournament.account.admin.id
      sign_in User.first(:conditions => ['id NOT IN ?', ids)
    end
    # non-participant joining tournament
    context "on POST to :create" do
      should_respond_with :success
      should_create Participation
      should_change("the number of pending participants", :by => 1) { @tournament.pending_participants.count }
      should "be a pending participant" do
        assert_equal @tournament.pending_participants.find_by_user_id(@user.id).count, 1
      end
    end
    
    # non-participant adding cohost
    context "on POST to :add_cohost" do
      should_respond_with :unauthorized
      should_not_change("the number of cohosts") { @tournament.cohosts.count }
    end
    
    # non-participant removing participant
    context "on DELETE to :deny" do
      should_respond_With :unauthorized
      should_not_change("the number of participants") { @tournament.participants.count }
    end
  end
end
