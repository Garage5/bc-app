require File.dirname(__FILE__) + '/../spec_helper'
 
describe ParticipationsController do
  fixtures :all
  integrate_views
  
  it "create action should render new template when model is invalid" do
    Participation.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    Participation.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(root_url)
  end
  
  it "update action should render edit template when model is invalid" do
    Participation.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Participation.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    Participation.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Participation.first
    response.should redirect_to(root_url)
  end
  
  it "destroy action should destroy model and redirect to index action" do
    participation = Participation.first
    delete :destroy, :id => participation
    response.should redirect_to(root_url)
    Participation.exists?(participation.id).should be_false
  end
end
