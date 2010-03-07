# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_todonkey_session',
  :secret => '1508ee18bc61edd33a359509dcf533246d301c496ecd004fac811bfd619ae060be55f0f10e904f6a55872f7967277bb87d1342c183b4e812dbdf808d33d0e6b6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
