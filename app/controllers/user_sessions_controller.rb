class UserSessionsController < ApplicationController
  before_filter :login_required, :only => [:destroy]
  def new
    @user_session = UserSession.new
    render :layout => 'lite'
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully created user session."
      redirect_back_or_default root_url
    else
      render :action => 'new', :layout => 'lite'
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Successfully destroyed user session."
    redirect_to login_url
  end
end
