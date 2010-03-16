BlueLightSpecial.configure do |config|
  config.mailer_sender        = 'donotreply@example.com'
  config.impersonation_hash   = 'REPLACE WITH A LONG HASH HERE'
  config.use_facebook_connect = true
  config.facebook_api_key     = 'KEY'
  config.facebook_secret_key  = 'SECRET'
end
