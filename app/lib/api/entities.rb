# frozen_string_literal: true

module API
  class Entities < ::Grape::API
    prefix :api

    resource :entities do
      desc 'Show entity'

      get ':id' do
        Interactors::Entities::Get.call(id: params[:id]).object
      end
    end
  end
end
