require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  setup do
    10.times { Factory.create(:user) }
    
    users      = User.all
    account    = Factory.create(:account, :admin => users.shift)
    tournament = Factory.create(:tournament, :account => account, :use_teams => true)

    4.times { users.shift.join_tournament(tournament).accept!}
    
    team = Factory.create(:team, :tournament_id => tournament.id)
    team.memberships.create(:member => tournament.active_participants.first, :captain => true)
    
    2.times { Participation.create(:tournament => tournament, :participant => users.shift, :state => 'cohost')}
  end
  
  context 'A Host' do
    setup { sign_in Account.first.admin }
    
    context 'on get to :new' do
      setup { get_new }
      should_respond_with :unauthorized
    end
    
    context 'on POST to :create' do
      setup { post_create }
      should_respond_with :unauthorized
      should_not_change('the number of teams') { Tournament.first.teams.count }
    end
    
    context 'on DELETE to :destroy' do
      setup { delete_destroy }
      should_respond_with :found
      should_destroy Team
      should_destroy Membership
    end
    
    context 'on GET to :edit' do
      setup { get_edit }
      should_respond_with :unauthorized
    end
    
    context 'on PUT to :update' do
      setup { put_update }
      should_respond_with :unauthorized
    end
  end

  context 'A Co-host' do
    setup { sign_in Tournament.first.cohosts.first }
    
    context 'on get to :new' do
      setup { get_new }
      should_respond_with :unauthorized
    end
    
    context 'on POST to :create' do
      setup { post_create }
      should_respond_with :unauthorized
      should_not_change('the number of teams') { Tournament.first.teams.count }
    end
    
    context 'on DELETE to :destroy' do
      setup { delete_destroy }
      should_respond_with :found
      should_destroy Team
      should_destroy Membership
    end
    
    context 'on GET to :edit' do
      setup { get_edit }
      should_respond_with :unauthorized
    end
    
    context 'on PUT to :update' do
      setup { put_update }
      should_respond_with :unauthorized
    end
  end
  
  # context 'A Participant not in a team' do
  #   setup { sign_in User.find(3)}
  #   
  #   should 'not be in a team' do
  #     assert !Membership.exists?(:team_id => Team.first.id, :member_id => @controller.current_user.id)
  #   end
  #   
  #   context 'on get to :new' do
  #     setup { get_new }
  #     should_respond_with :success
  #   end
  #   
  #   context 'on POST to :create' do
  #     setup { post_create }
  #     should_respond_with :success
  #     should_create Team
  #     should_create Membership
  #   end
  #   
  #   context 'on DELETE to :destroy' do
  #     setup { delete_destroy }
  #     should_respond_with :unauthorized
  #     should_not_change('the number of teams') { Tournament.first.teams.count }
  #   end
  #   
  #   context 'on GET to :edit' do
  #     setup { get_edit }
  #     should_respond_with :unauthorized
  #   end
  #   
  #   context 'on PUT to :update' do
  #     setup { put_update }
  #     should_respond_with :unauthorized
  #   end
  # end
  # 
  # context 'A Team Captain' do
  #   context 'on get to :new' do
  #     setup { get_new }
  #     should_respond_with :unauthorized
  #   end
  #   
  #   context 'on POST to :create' do
  #     setup { post_create }
  #     should_respond_with :unauthorized
  #     should_not_change('the number of teams') { Tournament.first.teams.count }
  #   end
  #   
  #   context 'on DELETE to :destroy' do
  #     setup { delete_destroy }
  #     should_respond_with :success
  #     should_destroy Team
  #   end
  #   
  #   context 'on GET to :edit' do
  #     setup { get_edit }
  #     should_respond_with :success
  #   end
  #   
  #   context 'on PUT to :update' do
  #     setup { put_update(:team => {:name => 'New Team Name'}) }
  #     should_respond_with :success
  #     should_change('the team name', :to => 'New Team Name')
  #   end
  # end
  # 
  # context 'A Team Member' do
  #   context 'on get to :new' do
  #     setup { get_new }
  #     should_respond_with :unauthorized
  #   end
  #   
  #   context 'on POST to :create' do
  #     setup { post_create }
  #     should_respond_with :unauthorized
  #     should_not_change('the number of teams') { Tournament.first.teams.count }
  #   end
  #   
  #   context 'on DELETE to :destroy' do
  #     setup { delete_destroy }
  #     should_respond_with :unauthorized
  #     should_not_change('the number of teams') { Tournament.first.teams.count }
  #   end
  #   
  #   context 'on GET to :edit' do
  #     setup { get_edit }
  #     should_respond_with :success
  #   end
  #   
  #   context 'on PUT to :update' do
  #     setup { put_update(:team => {:name => 'New Team Name'}) }
  #     should_respond_with :success
  #     should_change('the team name', :to => 'New Team Name')
  #   end
  # end
  # 
  # context 'A Non-participant' do
  #   context 'on get to :new' do
  #     setup { get_new }
  #     should_respond_with :unauthorized
  #   end
  #   
  #   context 'on POST to :create' do
  #     setup { post_create }
  #     should_respond_with :unauthorized
  #   end
  #   
  #   context 'on DELETE to :destroy' do
  #     setup { delete_destroy }
  #     should_respond_with :unauthorized
  #   end
  #   
  #   context 'on GET to :edit' do
  #     setup { get_edit }
  #     should_respond_with :unauthorized
  #   end
  #   
  #   context 'on PUT to :update' do
  #     setup { put_update }
  #     should_respond_with :unauthorized
  #   end
  # end
  
  def get_new
    @controller.stubs(:current_account).returns(Account.first)
    get :new, :tournament_id => Tournament.first.id
  end
  
  def post_create(attributes = {})
    post :create, :tournament_id => Tournament.first.id, :team => Factory.attributes_for(:team).merge(attributes)
  end
  
  def delete_destroy(id = nil)
    delete :destroy, :tournament_id => Tournament.first.id, :id => id || Team.first.id
  end
  
  def get_edit(id = nil)
    @controller.stubs(:current_account).returns(Account.first)
    get :edit, :tournament_id => Tournament.first.id, :id => id || Team.first.id
  end
  
  def put_update(id = nil, attributes = {})
    put :update, :tournament_id => Tournament.first.id, :id => id || Team.first.id, :team => {:name => 'Changed'}.merge(attributes)
  end
end
