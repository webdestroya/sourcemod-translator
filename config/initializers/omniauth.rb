OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  # Steam SSO
  provider :steam, ENV['STEAM_WEB_API_KEY']
  provider :allied_modders, "translator", "9b4f82f96d2d50a411d432d99eb0f520"
end