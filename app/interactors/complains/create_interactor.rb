# frozen_string_literal: true

module Complains
  class CreateInteractor
    include ApplicationInteractor
    delegate :current_user, :params, to: :context

    def call
      complain = Complain.create!(user: current_user, text: params[:text], data: params[:data])
      context.object = { id: complain.id }
    end
  end
end
