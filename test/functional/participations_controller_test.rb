require 'test_helper'

class ParticipationsControllerTest < ActionController::TestCase  
  setup do
    10.times { Factory.create(:user) }
    
    users      = User.all
    account    = Factory.create(:account, :admin => users.shift)
    tournament = Factory.create(:tournament, :account => account)

    4.times { users.shift.join_tournament(tournament).accept!}
    2.times { Participation.create(:tournament => tournament, :participant => users.shift, :state => 'cohost')}
  end


  context "A Host" do
    setup do
      sign_in Account.first.admin
    end
    # host joining the tournament
    context "on POST to :create" do
      setup { post :create, {:tournament_id => Tournament.first.id} }
      
      should_respond_with :unauthorized
      should_set_the_flash_to "You are not authorized to access this page."
      should_not_change("the number of participants") { Tournament.first.participants.count }
    end
    
    # host adding a cohost
    context "on POST to :add_cohost" do
      setup { post :add_cohost, {:tournament_id => Tournament.first.id, :user => User.last.username} }
      
      # should_respond_with :success
      should_create Participation
      should_change("the number of cohosts", :by => 1) { Tournament.first.cohosts.count }
    end
    
    # host removing a participant
    context "on DELETE to :deny" do
      setup do
        delete :deny, {:tournament_id => Tournament.first.id, :participant => Tournament.first.participants.first.id}
      end
      
      should_respond_with :found
      should_destroy Participation
      should_change("the number of participants", :by => -1) { Tournament.first.participants.count }
    end

    # host removing a participant when the tournament has started
    context "on DELETE to :deny when tournament started" do
      setup do
        Tournament.first.update_attributes(:state => 'started')
        delete :deny, {:tournament_id => Tournament.first.id, :participant => Tournament.first.participants.first.id}
      end
      
      should_respond_with :unauthorized
      should_set_the_flash_to "You are not authorized to access this page."
      should_not_change("the number of participants") { Tournament.first.participants.count }
    end
  end
  
  
  context "A Cohost" do
    setup do
      sign_in Tournament.first.cohosts.first
    end
    # cohost joining the tournament
    context "on POST to :create" do
      setup { post :create, {:tournament_id => Tournament.first} }

      should_respond_with :unauthorized
      should_not_change("the number of participants") { Tournament.first.participants.count }
    end
    
    # cohost adding another cohost
    context "on POST to :add_cohost" do
      setup { post :create, {:tournament_id => Tournament.first, :user => User.last.username} }
      
      should_respond_with :unauthorized
      should_not_change("the number of cohosts") { Tournament.first.cohosts.count }
    end
    
    # cohost removing participation
    context "on DELETE to :deny" do
      setup do
        delete :deny, {:tournament_id => Tournament.first.id, :participant => Tournament.first.active_participants.first.id}
      end
      
      should_respond_with :found
      should_destroy Participation
      should_change("the number of participants", :by => -1) { Tournament.first.participants.count }
    end
    
    # cohost removing other cohost
    context "on DELETE to :deny for other cohost" do
      setup do
        cohost = Tournament.first.cohosts.first(:offset => 1)
        delete :deny, {:participant => cohost.id, :tournament_id => Tournament.first.id}
      end
      
      should_respond_with :unauthorized
      should_set_the_flash_to 'You are not authorized to access this page.'
      should_not_change("the number of cohosts") { Tournament.first.cohosts.count }
    end
    
    # cohost removing participant when tournament started
    context "on DELETE to :deny when tournament started" do
      setup do
        Tournament.first.update_attributes(:state => 'started')
        delete :deny, {:tournament_id => Tournament.first.id, :participant => Tournament.first.active_participants.first.id}
      end
      
      should_respond_with :unauthorized
      should_not_change("the number of participants") { Tournament.first.participants.count }
    end
  end
  
  
  context "A Participant" do
    setup do
      sign_in Tournament.first.active_participants.first
    end
    
    # participant joing tournament twice
    context "on POST to :create" do
      setup do
        post :create, {:tournament_id => Tournament.first.id}
      end
      
      should_respond_with :unauthorized
      should_set_the_flash_to "You are not authorized to access this page."
      should_not_change("the number of pending participants") { Tournament.first.pending_participants.count }
    end
    
    # participant adding a cohost
    context "on POST to :add_cohost" do
      setup do
        post :add_cohost, {:tournament_id => Tournament.first, :participant => User.last}
      end
      
      should_respond_with :unauthorized
      should_set_the_flash_to 'You are not authorized to access this page.'
      should_not_change("the number of cohosts") { Tournament.first.cohosts.count }
    end
    
    # participant removing other participant
    context "on DELETE to :deny for not own participation" do
      setup do
        delete :deny, {:tournament_id => Tournament.first, :participant => Tournament.first.participants.first(:offset => 1)}
      end
      
      should_respond_with :unauthorized
      should_not_change("the number of participants") { Tournament.first.participants.count }
    end
    
    # participant removing self
    context "on DELETE to :deny for own participation" do
      setup do
        post :deny, {:tournament_id => Tournament.first, :participant => warden.user.id}
      end
      # should_respond_with :success
      should_destroy Participation
      should_change("the number of participants", :by => -1) { Tournament.first.participants.count }
      should "not be a participant anymore" do
        assert !Tournament.first.participants.exists?(warden.user.id)
      end
    end
    
    # participant removing self when tournament started
    context "on DELETE to :deny for own participation when tournament started" do
      setup do
        Tournament.first.update_attributes(:state => 'started')
        post :deny, {:tournament_id => Tournament.first.id, :participant => warden.user.id }
      end
      
      should_respond_with :unauthorized
      should_not_change("the number of participants") { Tournament.first.participants.count }
      should "still be a participant" do
        assert Tournament.first.participants.exists?(warden.user.id)
      end
    end
  end
  
  
  context "A Non-participant" do
    setup do
      ids = Tournament.first.participants.map(&:id).push(Tournament.first.account.admin.id)
      sign_in User.first(:conditions => ['id NOT IN (?)', ids])
    end
    # non-participant joining tournament
    context "on POST to :create" do
      setup { post :create, { :tournament_id => Tournament.first } }
      
      # should_respond_with :success
      should_create Participation
      should_change("the number of pending participants", :by => 1) { Tournament.first.pending_participants.count }
      should "be a pending participant" do
        assert Tournament.first.pending_participants.exists?(warden.user.id)
      end
    end
    
    # non-participant adding cohost
    context "on POST to :add_cohost" do
      setup { post :add_cohost, {:tournament_id => Tournament.first.id, :participant_id => User.last} }
      
      should_respond_with :unauthorized
      should_not_change("the number of cohosts") { Tournament.first.cohosts.count }
    end
    
    # non-participant removing participant
    context "on DELETE to :deny" do
      setup do 
        delete :deny, {
          :tournament_id => Tournament.first.id, 
          :participant_id => Tournament.first.participants.first.id
        }
      end
      
      should_respond_with :unauthorized
      should_not_change("the number of participants") { Tournament.first.participants.count }
    end
  end

  
  context "A Teams Tournament" do
    setup do
      @tournament = Factory(:tournament, :use_teams => true)
      @user = User.find_by_username('bryan')
      @team = Team.new :name => 'Navi', :captain => @user, :tournament_id => @tournament.id, :battleids =>  ['matt', 'james']
    end
    
  end
end
