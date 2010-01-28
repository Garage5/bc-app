require 'test_helper'
require 'coulda'
include Coulda

Feature "Create an Account", :testcase_class => ActionController::IntegrationTest do
  in_order_to "play with the application"
  as_a "potential customer"
  i_want_to "create an account"
  
  def free_plan_url
    'http://signup.tbbdev.com/signup/Free'
  end
  
  Scenario "User does not have a BattleID" do
    # Given "I am not logged in"
    
    When  "I go to the new battleid page after selecting the Free plan" do
      visit "/users/new?ref=#{free_plan_url}"
    end
    
    When  "I submit the new BattleID form correctly" do
      fill_in 'Email', :with => 'test@example.com'
      fill_in 'Username', :with => 'test'
      fill_in 'Password', :with => 'password'
      fill_in 'Confirm Password', :with => 'password'
      click_button 'Create my BattleID'
    end
    
    Then "I should now have a BattleID" do
      assert_equal 'Successfully created a BattleID', flash[:notice]
    end
    
    Then  "I should be redirected to the signup page for the Free plan" do
      # assert_equal free_plan_url, session[:return_to]
      assert_equal free_plan_url, path
    end
    
    # Then  "I should see my BattleID as the admin"
  end

  Scenario "User has a BattleID" do
    Given "I am not logged in"
    When  "I go to the login page after selecting the Free plan"
    When  "I submit the login form correctly"
    Then  "I should be redirected to the signup page for the Free plan"
    Then  "I should see my BattleID as the admin"
  end
end