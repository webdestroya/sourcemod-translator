OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  # Steam SSO
  provider :steam, ENV['STEAM_WEB_API_KEY']
end