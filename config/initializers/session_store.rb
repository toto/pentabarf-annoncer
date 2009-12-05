# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_announcer_session',
  :secret      => '88c9a416d716359368a0bdb5393a5661782b37da4dd5c29eba10ec705013a23c93b99585e31a000e55aead47e894f0d6efd56a79dae8e33677cb96177434bd04'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
