require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  
  context 'A new account' do
    setup do
      @account = Factory.build(:account)
    end
    
    context 'with valid user' do
      setup do
        @account.user = @user = Factory.build(:user)
        @account.save
      end
      
      should_create User
      should_create Account
      should 'create an account with the new user as admin' do
        assert@account.admin == @user
      end
    end
    
    context 'with invalid user' do
      setup do
        @account.user = @user = User.new(Factory.attributes_for(:user).merge(:username => ''))
        @account.save
      end
      
      should_not_change('the number of users') { User.count }
      should_not_change('the number of accounts') { Account.count }
      should 'have errors' do
        assert !@account.errors.empty?
      end
    end
      
    # context 'with valid login' do
    #   setup do
    #     @account.user = 
    #   end
    #   should_not_create User
    #   should_create Account
    #   should 'create an account with logged in user as admin' do
    #     assert @account.admin == user
    #   end
    # end
    # 
    # context 'with invalid login' do
    #   should_not_create User
    #   should_not_create Account
    # end
    
  end
  
end
