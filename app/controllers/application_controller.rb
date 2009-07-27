# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_user_session, :current_user
  
  before_filter :http_authentication
  
  def http_authentication
    authenticate_or_request_with_http_basic do |user, pass|
      user == 'dev' && pass == 'plankton'
    end
  end

  private
  def find_instance
    @instance = Instance.first
  end
  
  def find_tournament
    tournament_id = params[:tournament_id] || params[:id]
    @tournament = Tournament.find(tournament_id)
  end
  
  def must_be_host
    return false unless current_user.is_hosting?(@tournament)
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  
  def login_required
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_url
      return false
    end
  end
  
  def store_location
    return if @prevent_store_location == true
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end