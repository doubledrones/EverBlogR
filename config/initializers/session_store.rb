# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_everblogr_session',
  :secret      => 'f49b008e011558a59a588985040497993ba7ba8f46a7a0ffd3bf19faa95d85d276be214417b8d79ed5c371f30ab89d6616e27eb1cdefa363be96eff1224160c4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
