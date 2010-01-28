require 'test_helper'

class SignupProcessTest < ActionController::IntegrationTest
  
  def free_plan_url
    'http://signup.tbbdev.com/signup/Free'
  end
  
  context 'A User without a BattleID' do
    
    should 'be redirected to the signup page for the Free plan after creating a BattleID' do
      visit "/users/new?ref=#{free_plan_url}"
      fill_in 'Email', :with => 'test@example.com'
      fill_in 'Username', :with => 'test'
      fill_in 'Password', :with => 'password'
      fill_in 'Confirm Password', :with => 'password'
      click_button 'Create my BattleID'
      assert_equal free_plan_url, path
    end
    
  end
  
  context 'A User with a BattleID' do
    
    # should 'be redirected to the signup page for the Free plan after logging in' do
    #   visit "/sessions/login?ref=#{free_plan_url}"
    #   fill_in 'Email', :with => 'test@example.com'
    #   fill_in 'Username', :with => 'test'
    #   fill_in 'Password', :with => 'password'
    #   fill_in 'Confirm Password', :with => 'password'
    #   click_button 'Create my BattleID'
    #   assert_equal free_plan_url, path
    # end
    
  end
  
end