class UsersController < ApplicationController
  before_filter :login_required, :only => [:update]
  def new
    @user = User.new
    render :layout => 'lite'
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created user."
      redirect_to '/preview/accounts/dashboard'
    else
      render :action => 'new', :layout => 'lite'
    end
  end
  
  def profile
    @user = User.find_by_login(params[:id])
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
