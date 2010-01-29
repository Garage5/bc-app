class UsersController < ApplicationController
  before_filter :login_required, :only => [:update]
  
  def new
    @user = User.new
    session[:'user.return_to'] = params[:return_to] if params[:return_to] 
    render :layout => 'accounts'
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      # sign_in_and_redirect @user
      flash[:notice] = "Successfully created a BattleID"
      sign_in_and_redirect @user
      # edirect_back_or_default stored_location_for(:user)
    else
      @ref = params[:return_to] if params[:return_to]
      render :action => 'new', :layout => 'accounts'
    end
  end
  
  def profile
    @user = User.find_by_username(params[:id])
  end
  
  def update
    # for now, only the current user
    @user = current_user
    # can't change BattleID
    params[:user].delete(:login) if params[:user].has_key?(:login)
    if request.xhr?
      @user.attributes = params[:user]
      @success = @user.save
    else
      @user.update_attributes(params[:user])
      redirect_to [:profile, @user]
    end
  end
end
