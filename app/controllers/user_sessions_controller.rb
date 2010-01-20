class UserSessionsController < ApplicationController
  before_filter :login_required, :only => [:destroy]
  layout 'lite'
  
  def new
    @user_session = UserSession.new
    render :layout => 'accounts'
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      if params[:ref]
        redirect_to CGI.unescape(params[:ref])
      else
        redirect_back_or_default root_url
      end
    else
      render :action => 'new', :layout => 'accounts'
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Successfully destroyed user session."
    redirect_back_or_default root_url
  end
end
