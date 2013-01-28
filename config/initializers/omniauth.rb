OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  # Steam SSO
  provider :steam, ENV['STEAM_WEB_API_KEY']

  # OAUTH login to AlliedModders via @asherkin
  provider :allied_modders, ENV['ALLIEDMODDERS_CLIENTID'], ENV['ALLIEDMODDERS_SECRET']
end