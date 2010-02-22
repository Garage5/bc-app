require 'test_helper'

class AccountTest < ActionController::TestCase
  
  context 'A new account' do
    
    context 'with signup' do
      
      context '(valid user)' do
        should_create User
        should_create Account
        should 'create an account with the new user as admin' do
          @account.admin == @user
        end
      end
      
      context '(invalid user)' do
        should_not_create User
        should_not_create Account
        should 'have errors on user' do
          assert !@account.errors.on(:admin).empty?
        end
      end
      
    end
    
    # context 'with login' do
    #   
    #   context '(valid login)' do
    #     should_not_create User
    #     should_create Account
    #   end
    #   
    #   context '(invalid login)' do
    #     should_not_create User
    #     should_not_create Account
    #   end
    #   
    # end
    
  end
  
end
