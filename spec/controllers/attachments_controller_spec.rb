require File.dirname(__FILE__) + '/../spec_helper'
 
describe AttachmentsController do
  fixtures :all
  integrate_views
  
  it "create action should render new template when model is invalid" do
    Attachment.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    Attachment.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(root_url)
  end
  
  it "destroy action should destroy model and redirect to index action" do
    attachment = Attachment.first
    delete :destroy, :id => attachment
    response.should redirect_to(root_url)
    Attachment.exists?(attachment.id).should be_false
  end
end
