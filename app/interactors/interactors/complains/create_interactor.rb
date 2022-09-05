# frozen_string_literal: true

module Interactors
  module Complains
    class CreateInteractor
      include ApplicationInteractor
      delegate :current_user, :params, to: :context

      def call
        Complain.create!(user: current_user, text: params[:text], data: params[:data])
      end
    end
  end
end
