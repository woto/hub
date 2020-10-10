# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def callback
    Rails.logger.info(request.env['omniauth.auth'])
    oauth = OauthStruct.new(request.env['omniauth.auth'])
    user = nil
    ActiveRecord::Base.transaction do
      idn = Identity.where(provider: oauth.provider, uid: oauth.uid).first_or_initialize
      user = if idn.persisted?
               # we are retrieving user and do not touching them even identity e-mail where changed
               idn.user
             else
               # we are creating new user or finding them by identity email
               User.where(email: oauth.info[:email]).first_or_create!(password: Devise.friendly_token[0, 20])
             end

      # if identity is old and user is old and gotten from identity
      # if identity is new and user is old and found by email (were registered by email then logined with facebook)
      # if identity is new and user is new (absolutely new user)
      idn.assign_attributes(auth: oauth, user: user)
      idn.save!

      establish_avatar(oauth, user)
      establish_profile(oauth, user)
    end

    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message!(:notice, :success, kind: oauth.provider)
    else
      redirect_to root_path
    end
  end

  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  private

  def establish_profile(oauth, user)
    return if user.profile.present?

    user.create_profile(
      name: oauth.info[:name]
    )
  end

  def establish_avatar(oauth, user)
    return if user.avatar.attached?

    downloaded_image = URI.open(oauth.info[:image])
    user.avatar.attach(io: downloaded_image, filename: 'avatar.jpg')
  end
end
