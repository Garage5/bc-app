class UsersController < ApplicationController
  before_filter :login_required, :only => [:update]
  
  def show
    @user = User.find_by_username(params[:id])
  end
  
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
  
  def update
    @user = current_user
    if request.xhr?
      @user.attributes = params[:user]
      @success = @user.save
    else
      unless @user.update_attributes(params[:user])
        y @user.errors.full_messages
        flash[:alert] = @user.errors.on(:avatar)
      end
      redirect_to @user
    end
  end
end
