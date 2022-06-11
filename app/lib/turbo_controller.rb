# frozen_string_literal: true

# # NOTE: taken from https://gorails.com/episodes/devise-hotwire-turbo?autoplay=1
class TurboController < ApplicationController
  # protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  class Responder < ActionController::Responder
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    rescue ActionView::MissingTemplate => error
      if get?
        raise error
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        redirect_to navigation_location
      end
    end
  end

  self.responder = Responder
  respond_to :html, :turbo_stream, :json
end
