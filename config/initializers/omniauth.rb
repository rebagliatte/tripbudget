OmniAuth.config.logger = Rails.logger
omniauth_config = JSON.parse(File.open(File.join(Rails.root, 'config/omniauth.json')).read, symbolize_names: true)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, omniauth_config[:twitter_key], omniauth_config[:twitter_secret]
  provider :facebook, omniauth_config[:facebook_api_key], omniauth_config[:facebook_secret], scope: 'email'
end
