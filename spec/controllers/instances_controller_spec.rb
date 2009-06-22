require File.dirname(__FILE__) + '/../spec_helper'
 
describe InstancesController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    Instance.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    Instance.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(instances_url)
  end
  
  it "edit action should render edit template" do
    get :edit, :id => Instance.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    Instance.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Instance.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    Instance.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Instance.first
    response.should redirect_to(instances_url)
  end
  
  it "destroy action should destroy model and redirect to index action" do
    instance = Instance.first
    delete :destroy, :id => instance
    response.should redirect_to(instances_url)
    Instance.exists?(instance.id).should be_false
  end
end
