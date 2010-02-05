ActionController::Routing::Routes.draw do |map|
  map.devise_for :user, :as => :sessions, :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  map.resources :users
  
  map.with_options :conditions => {:subdomain => 'signup'} do |signup|
    signup.root :controller => 'accounts', :action => 'index'
    signup.connect '/signup/d/:discount', :controller => 'accounts', :action => 'plans'
    signup.thanks '/signup/thanks', :controller => 'accounts', :action => 'thanks'
    signup.create '/signup/create/:discount', :controller => 'accounts', :action => 'create', :discount => nil
    signup.new_account '/signup/:plan/:discount', :controller => 'accounts', :action => 'new', :plan => nil, :discount => nil
  end

  # ACCOUNT (SaaS) ROUTES
  # map.with_options :domain => 'tbb.local', :conditions => {:subdomain => false, :domain => 'tbb.local'} do |home|
  # map.subdomain nil do |home|
  #   home.root :controller => 'home', :action => 'index'
  # 
  # end
  
  # PORTAL ROUTES
  map.with_options :conditions => {:subdomain => /^(?!www|admin|signup$).+/} do |account|
    account.resource :account, :collection => { :dashboard => :get, :thanks => :get, :plans => :get, :billing => :any, :paypal => :any, :plan => :any, :plan_paypal => :any, :cancel => :any, :canceled => :get }
    
    account.root :controller => 'accounts', :action => 'show'
    account.settings '/settings', :controller => 'accounts', :action => 'edit', :conditions => {:method => :get}
    account.settings '/settings', :controller => 'accounts', :action => 'update', :conditions => {:method => :put}
    
    account.resources :tournaments, :member => {:rules => :get, :start => :put, :brackets => :get}, :collection => {:calendar => :get} do |tournaments|
      tournaments.with_options :conditions => {:subdomain => /^(?!www|admin$).+/} do |tournament|
        tournament.resources :participants, :controller => :participations, :collection => {:accept => :put, :deny => :delete, :add_cohost => :post}
        tournament.resources :messages, :has_many => [:comments]
        tournament.resources :files, :controller => :attachments
        tournament.resources :teams
        tournament.resources :matches, :has_many => [:comments] do |match|
          match.resources :slots, :member => {
            :manage => :get, 
            :advance => :put, 
            :disqualify => :put, 
            :revert => :put,
            :won => :put,
            :lost => :put
          }, :conditions => {:subdomain => /^(?!www|admin$).+/}
        end
      end
    end
  end

  # ADMIN ROUTES
  map.with_options :conditions => {:subdomain => 'admin'} do |subdom|
    subdom.root :controller => 'subscription_admin/subscriptions', :action => 'index'
    subdom.with_options(:namespace => 'subscription_admin/', :name_prefix => 'admin_', :path_prefix => nil) do |admin|
      admin.resources :subscriptions, :member => { :charge => :post }
      admin.resources :accounts
      admin.resources :subscription_plans, :as => 'plans'
      admin.resources :subscription_discounts, :as => 'discounts'
      admin.resources :subscription_affiliates, :as => 'affiliates'
      map.connect '/preview/*view', :controller => 'preview', :action => 'index'
      map.connect '/preview-lite/*view', :controller => 'preview', :action => 'lite'
    end
  end
end
