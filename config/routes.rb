ActionController::Routing::Routes.draw do |map|
  map.resources :rounds  
  map.resources :participations
  map.resources :attachments
  map.resources :comments
  map.resources :messages

  map.root :controller => 'instances', :action => 'show'
  
  map.login  '/login',  :controller => 'user_sessions', :action => 'new', :conditions => {:method => :get}
  map.login  '/login',  :controller => 'user_sessions', :action => 'create', :conditions => {:method => :post}
  
  map.signup '/signup', :controller => 'users', :action => 'new', :conditions => {:method => :get}
  map.signup '/signup', :controller => 'users', :action => 'create', :conditions => {:method => :post}
  
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.settings '/settings', :controller => 'instances', :action => 'settings', :conditions => {:method => :get}
  map.settings '/settings', :controller => 'instances', :action => 'settings', :conditions => {:method => :put}
  
  map.resources :user_sessions
  map.resources :users, :member => {:profile => :get}
  map.resources :instances
  
  map.resources :tournaments, :member => {:rules => :get, :start => :put, :brackets => :get}, :collection => {:calendar => :get} do |tournament|
    tournament.resources :participants, :controller => :participations, :collection => {:accept => :put, :deny => :delete, :add_cohost => :post}
    tournament.resources :messages, :has_many => [:comments]
    tournament.resources :files, :controller => :attachments
    tournament.resources :matches, :has_many => [:comments]do |match|
      match.resources :slots, :member => {:manage => :get, :advance => :put, :disqualify => :put, :revert => :put}
    end
    tournament.resources :teams, :member => {:join => :put, :decline => :delete}
  end

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect '/preview/*view', :controller => 'preview', :action => 'index'
  map.connect '/preview-lite/*view', :controller => 'preview', :action => 'lite'
end
