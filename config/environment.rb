# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
# RAILS_GEM_VERSION = '2.3.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem 'authlogic'
  # config.gem 'ryanb-acts-as-list', :lib => 'acts_as_list', :source => 'http://gems.github.com'
  config.gem 'rspec', :lib => false
  config.gem 'rspec-rails', :lib => false
  config.gem 'remarkable_rails', :lib => false
  config.gem 'thoughtbot-paperclip', :lib => 'paperclip', :source => "http://gems.github.com"
  config.gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => "http://gems.github.com"
  config.gem 'tlsmail'
  config.gem 'acts_as_markup'
  config.gem 'subdomain-fu'
  
  require 'array'
  require 'ostruct'
  OpenStruct.__send__(:define_method, :id) { @table[:id] || self.object_id }
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  begin
    require 'tlsmail'
    Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
	
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :address => 'smtp.gmail.com', 
      :port => 587, 
      :tls => true, 
      :enable_starttls_auto => true,
      :domain => 'thebattlebegins.com', 
      :authentication => :plain, 
      :user_name => 'no-reply@thebattlebegins.com', 
      :password => 'tbbdev'
    }
  rescue MissingSourceFile => e
    puts "Warning: skipping tlsmail settings as the gem is not installed."
    puts "The application will work, except for the e-mails. Run rake gems:install to fix this."
  end
end
ActionView::Helpers::InstanceTag::DEFAULT_FIELD_OPTIONS = {}
ActionView::Base.field_error_proc = Proc.new { |html_tag, instance|"<span class=\"fieldWithErrors\">#{html_tag}</span>" }

# jQuery Post bug fix
class Mime::Type
  delegate :split, :to => :to_s
end
