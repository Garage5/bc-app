require 'rubygems'

begin
  gem "test-unit"
rescue LoadError
end

begin
  gem "ruby-debug"
  require 'ruby-debug'
rescue LoadError
end

require 'test/unit'
require 'mocha'

ENV["RAILS_ENV"] = "test"
RAILS_ROOT = "anywhere"

gem 'activesupport', '= 2.3.5'
require 'active_support'

gem 'actionpack', '= 2.3.5'
require 'action_controller'

I18n.load_path << File.join(File.dirname(__FILE__), 'locales', 'en.yml')
I18n.reload!

class ApplicationController < ActionController::Base; end

# Add IR to load path and load the main file
ActiveSupport::Dependencies.load_paths << File.expand_path(File.dirname(__FILE__) + '/../lib')
require_dependency 'inherited_resources'

ActionController::Base.view_paths = File.join(File.dirname(__FILE__), 'views')

ActionController::Routing::Routes.draw do |map|
  map.connect ':controller/:action/:id'
end
