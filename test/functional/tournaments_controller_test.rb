require 'test_helper'

class TournamentsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Tournament.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Tournament.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Tournament.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to tournament_url(assigns(:tournament))
  end
  
  def test_edit
    get :edit, :id => Tournament.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Tournament.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Tournament.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Tournament.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Tournament.first
    assert_redirected_to tournament_url(assigns(:tournament))
  end
  
  def test_destroy
    tournament = Tournament.first
    delete :destroy, :id => tournament
    assert_redirected_to tournaments_url
    assert !Tournament.exists?(tournament.id)
  end
end
