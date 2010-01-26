# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include SslRequirement
  include SubscriptionSystem
  
  helper :all
  helper_method :allowed_domains
  protect_from_forgery
  
  before_filter :http_authentication
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You do not have permission to do that" #exception.message
    redirect_to root_url
  end
  
  # hack to override devise's SessionController layout
  layout :lite_if_devise
  
  def lite_if_devise
    if devise_controller? 
      "accounts"
    else 
      "application" 
    end
  end
  
  def http_authentication
    if Rails.env != 'production'
      authenticate_or_request_with_http_basic do |user, pass|
        user == 'dev' && pass == 'tbbd3v'
      end 
      warden.custom_failure! if performed?
    end
  end

  private
  
  def find_tournament
    tournament_id = params[:tournament_id] || params[:id]
    @tournament = Tournament.find(tournament_id)
  end
  
  def must_be_admin
    redirect_to root_url unless current_user == current_account.admin
  end
  
  def must_be_host
    redirect_back_or_default(root_url) unless current_user.is_hosting?(current_account)
  end
  
  def must_be_official
    redirect_back_or_default(root_url) unless @tournament.officials.include?(current_user)
  end
  
  def allowed_domains
    Instance::ALLOWED_DOMAINS
  end
  
  def login_required
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      hostname = TBBLIVE_DOMAIN[Rails.env.to_sym]
      hostname += ":#{request.port}" unless request.port == 80
      redirect_to new_user_session_url
      return false
    end
  end

  # def logged_in?
  #   !!current_user
  # end
  
  def store_location
    return if @prevent_store_location == true
    session[:return_to] = request.request_uri
    # host = request.host
    # host += ":#{request.port}" unless request.port == 80
    # session[:return_to] = host
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

end
