require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  context 'A user without a BattleID' do
    
    context "on GET to :new" do
      setup { get :new, :return_to => 'http://signup.tbbdev.com/signup/Free' }
      should_set_session(:'user.return_to') { 'http://signup.tbbdev.com/signup/Free' }
    end
    
    context "on POST to :create" do
      setup do
        session[:'user.return_to'] = 'http://signup.tbbdev.com/signup/Free'
        
        post :create, {:user => {
          :username => 'jakesully', 
          :email => 'jake@example.com', 
          :password => 'password', 
          :password_confirmation => 'password'
        }}
      end
      
      should_set_the_flash_to 'Successfully created a BattleID'
      should_create User
      should_redirect_to('the signup page') { 'http://signup.tbbdev.com/signup/Free' }
    end
    
  end
  
end
