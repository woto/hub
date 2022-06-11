# frozen_string_literal: true

# NOTE: obsolete? was used in popover
module API
  class Entities < ::Grape::API
    prefix :api
    auth :api_key

    resource :entities do
      desc 'Show entity' do
        security [{ api_key: [] }]
      end

      get ':id' do
        Interactors::Entities::Get.call(id: params[:id]).object
      end
    end
  end
end
