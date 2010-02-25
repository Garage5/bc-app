require 'test_helper'

class MembershipsControllerTest < ActionController::TestCase
  context 'A Host' do
    
    context 'on POST to :create' do
      setup { post :create }
      should_respond_with :unauthorized
    end
    
    context 'on DELETE to :destroy' do
      setup { delete :destroy }
      should_respond_with :unauthorized
    end
  end

  # context 'A Co-Host' do
  #   context 'on GET to :new'
  #   context 'on POST to :create'
  #   context 'on DELETE to :destroy'
  # end
  # 
  # context 'A Team Captain' do
  #   context 'on GET to :new'
  #   context 'on POST to :create'
  #   context 'on DELETE to :destroy'
  # end
  # 
  # context 'A Team Member' do
  #   context 'on GET to :new'
  #   context 'on POST to :create'
  #   context 'on DELETE to :destroy'
  # end
  # 
  # context 'A Participant not in a team' do
  #   context 'on GET to :new'
  #   context 'on POST to :create'
  #   context 'on DELETE to :destroy'
  # end
  # 
  # context 'A Non-participant' do
  #   context 'on GET to :new'
  #   context 'on POST to :create'
  #   context 'on DELETE to :destroy'
  # end
end
