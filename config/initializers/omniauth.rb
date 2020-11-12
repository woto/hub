# frozen_string_literal: true

# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :developer unless Rails.env.production?
#   provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
# end
#
# config.omniauth :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET']

# https://github.com/omniauth/omniauth/issues/593#issuecomment-332543230
# https://github.com/plataformatec/devise/wiki/OmniAuth-with-multiple-models

OmniAuth.config.path_prefix = '/users/auth'

Rails.application.config.middleware.use OmniAuth::Builder do
  # https://developer.twitter.com/en/apps
  # provider :twitter, ENV['TWITTER_ID'], ENV['TWITTER_SECRET'], callback_path: '/users/auth/twitter/callback'

  # https://developers.facebook.com/apps/
  provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_SECRET'], callback_path: '/users/auth/facebook/callback'

  # https://github.com/settings/developers
  # provider :github, ENV['GITHUB_ID'], ENV['GITHUB_SECRET'], callback_path: '/users/auth/github/callback'

  # https://www.instagram.com/developer/clients/manage/
  # provider :instagram, ENV['INSTAGRAM_ID'], ENV['INSTAGRAM_SECRET'], callback_path: '/users/auth/instagram/callback'

  # https://console.developers.google.com/apis/credentials
  provider :google_oauth2, ENV['GOOGLE_ID'], ENV['GOOGLE_SECRET'], callback_path: '/users/auth/google_oauth2/callback'

  on_failure do |env|
    env['devise.mapping'] = Devise.mappings[:user]
    Users::OmniauthCallbacksController.action(:failure).call(env)
  end
end
