# frozen_string_literal: true

class Api::V1::Users::ConfirmationsController < Devise::ConfirmationsController
  include DoorkeeperTokenable
  respond_to :json

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super do |user|
      if user.persisted?
        render json: build_token_response(user).body and return
      end
    end
  end

end
