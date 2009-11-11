ActionController::Routing::Routes.draw do |map|
  map.resources :s3_uploads

  map.resources :rounds  
  map.resources :participations
  map.resources :attachments
  map.resources :comments
  map.resources :messages

  map.instance_root '', :controller => 'instances', :action => 'show', :condition => { :subdomain => /.+/ }
  map.root :controller => 'home', :action => 'index'
  
  map.login  '/login',  :controller => 'user_sessions', :action => 'new', :conditions => {:method => :get}
  map.login  '/login',  :controller => 'user_sessions', :action => 'create', :conditions => {:method => :post}
  
  # map.signup '/signup', :controller => 'users', :action => 'new', :conditions => {:method => :get}
  # map.signup '/signup', :controller => 'users', :action => 'create', :conditions => {:method => :post}
  
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  
  map.resources :user_sessions
  map.resources :users, :member => {:profile => :get}
  map.resources :instances
  
  # PORTAL ROUTES
  map.with_options :condition => { :subdomain => /.+/ } do |account|
    account.settings '/settings', :controller => 'accounts', :action => 'edit', :conditions => {:method => :get}
    account.settings '/settings', :controller => 'accounts', :action => 'update', :conditions => {:method => :put}
    
    account.resources :tournaments, :member => {:rules => :get, :start => :put, :brackets => :get}, :collection => {:calendar => :get} do |tournament|
      tournament.resources :participants, :controller => :participations, :collection => {:accept => :put, :deny => :delete, :add_cohost => :post}
      tournament.resources :teams do |team|
        team.invite '/invite/:user_id', :controller => 'teams', :action => 'invite',:path_prefix => '/tournaments/:tournament_id'
      end
      tournament.resources :messages, :has_many => [:comments]
      tournament.resources :files, :controller => :attachments
      tournament.resources :matches, :has_many => [:comments] do |match|
        match.resources :slots, :member => {
          :manage => :get, 
          :advance => :put, 
          :disqualify => :put, 
          :revert => :put,
          :won => :put,
          :lost => :put
        }
      end
      tournament.resources :teams, :member => {:join => :put, :decline => :delete}
    end
  end

  # ADMIN ROUTES
  map.with_options(:conditions => {:subdomain => AppConfig['admin_subdomain']}) do |subdom|
    subdom.root :controller => 'subscription_admin/subscriptions', :action => 'index'
    subdom.with_options(:namespace => 'subscription_admin/', :name_prefix => 'admin_', :path_prefix => nil) do |admin|
      admin.resources :subscriptions, :member => { :charge => :post }
      admin.resources :accounts
      admin.resources :subscription_plans, :as => 'plans'
      admin.resources :subscription_discounts, :as => 'discounts'
      admin.resources :subscription_affiliates, :as => 'affiliates'
    end
  end
  
  map.root :controller => "accounts", :action => "dashboard"
  
  # ACCOUNT (SaaS) ROUTES
  map.plans '/signup', :controller => 'accounts', :action => 'plans'
  map.connect '/signup/d/:discount', :controller => 'accounts', :action => 'plans'
  map.thanks '/signup/thanks', :controller => 'accounts', :action => 'thanks'
  map.create '/signup/create/:discount', :controller => 'accounts', :action => 'create', :discount => nil
  map.resource :account, :collection => { :dashboard => :get, :thanks => :get, :plans => :get, :billing => :any, :paypal => :any, :plan => :any, :plan_paypal => :any, :cancel => :any, :canceled => :get }
  map.new_account '/signup/:plan/:discount', :controller => 'accounts', :action => 'new', :plan => nil, :discount => nil
end
