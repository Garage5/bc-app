require File.dirname(__FILE__) + '/../spec_helper'
 
describe RoundsController do
  fixtures :all
  integrate_views
  
  it "update action should render edit template when model is invalid" do
    Round.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Round.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    Round.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Round.first
    response.should redirect_to(root_url)
  end
end
