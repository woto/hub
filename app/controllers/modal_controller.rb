# frozen_string_literal: true

# TODO: remove. demo modal
class ModalController < ApplicationController
  def index
    @uuid = SecureRandom.uuid
    @title = Faker::Lorem.sentence

    render json: {
      uuid: @uuid,
      content: render_to_string('/modal/index', locals: { uuid: @uuid, title: @title })
    }
  end
end
