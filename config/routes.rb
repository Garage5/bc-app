ActionController::Routing::Routes.draw do |map|
  map.resources :s3_uploads

  map.resources :rounds  
  map.resources :participations
  map.resources :attachments
  map.resources :comments
  map.resources :messages

  map.instance_root '', :controller => 'instances', :action => 'show', :condition => { :subdomain => /.+/ }
  map.root :controller => 'instances', :action => 'show'
  
  map.login  '/login',  :controller => 'user_sessions', :action => 'new', :conditions => {:method => :get}
  map.login  '/login',  :controller => 'user_sessions', :action => 'create', :conditions => {:method => :post}
  
  map.signup '/signup', :controller => 'users', :action => 'new', :conditions => {:method => :get}
  map.signup '/signup', :controller => 'users', :action => 'create', :conditions => {:method => :post}
  
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.settings '/settings', :controller => 'instances', :action => 'edit', :conditions => {:method => :get}
  map.settings '/settings', :controller => 'instances', :action => 'update', :conditions => {:method => :put}
  
  map.resources :user_sessions
  map.resources :users, :member => {:profile => :get}
  map.resources :instances
  
  map.resources :tournaments, :member => {:rules => :get, :start => :put, :brackets => :get}, :collection => {:calendar => :get} do |tournament|
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

  map.connect '/preview/*view', :controller => 'preview', :action => 'index'
  map.connect '/preview-lite/*view', :controller => 'preview', :action => 'lite'
end
