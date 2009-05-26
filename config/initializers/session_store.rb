# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bc-app_session',
  :secret      => '224138ec528cc9387e52f119e05275e45c14678caf9e485ff93c836f7136fb1ae1422ec1e8a56f3e405b8e7eb4c94667661bbe2550392acc5b47fdf0a88f8ef1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
