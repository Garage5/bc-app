require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  context 'A user with a BattleID' do
    
    # context "on GET to :new" do
    #   setup { get :new, :ref => 'http://signup.tbbdev.com/signup/Free' }
    #   should_set_session(:'user.return_to') { 'http://signup.tbbdev.com/signup/Free' }
    # end
    
    context "on POST to :create" do
      setup do
        Factory.create(:user, :username => 'jakesully')
        session[:'user.return_to'] = 'http://signup.tbbdev.com/signup/Free'
        post :create, {:user => {
          :username => 'jakesully',
          :password => 'password'
        }}
      end
      
      should_set_the_flash_to 'Signed in successfully.'
      should_redirect_to('the signup page') { 'http://signup.tbbdev.com/signup/Free' }
    end
    
  end
  
end
