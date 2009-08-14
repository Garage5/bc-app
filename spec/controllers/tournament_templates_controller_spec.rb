require File.dirname(__FILE__) + '/../spec_helper'
 
describe TournamentTemplatesController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "create action should render new template when model is invalid" do
    TournamentTemplate.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    TournamentTemplate.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(tournament_templates_url)
  end
  
  it "destroy action should destroy model and redirect to index action" do
    tournament_template = TournamentTemplate.first
    delete :destroy, :id => tournament_template
    response.should redirect_to(tournament_templates_url)
    TournamentTemplate.exists?(tournament_template.id).should be_false
  end
end
