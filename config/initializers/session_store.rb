# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_treetest_session',
  :secret      => 'cfaedb737f6d624346091d7c54eb2eb38ea3e1cd7f4509488693c9e433a000d5c5c66a8472495bb74b9047ddaa22c0f1aef4b2920c3c8524bdd0961f7d233972'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
