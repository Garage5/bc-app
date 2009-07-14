require File.dirname(__FILE__) + '/../spec_helper'
 
describe MatchesController do
  fixtures :all
  integrate_views
  
  it "show action should render show template" do
    get :show, :id => Match.first
    response.should render_template(:show)
  end
  
  it "update action should render edit template when model is invalid" do
    Match.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Match.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    Match.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Match.first
    response.should redirect_to(match_url(assigns[:match]))
  end
end
