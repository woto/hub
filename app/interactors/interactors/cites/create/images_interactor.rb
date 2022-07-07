# frozen_string_literal: true

module Interactors
  module Cites
    module Create
      class ImagesInteractor
        include ApplicationInteractor
        delegate :cite, :entity, :user, :params, to: :context

        contract do
          params do
            required(:cite)
            required(:entity)
            required(:user)
            required(:params).maybe do
              array(:hash) do
                required(:id)
                required(:destroy)
                required(:file)
              end
            end
          end
        end

        def call
          return if params.nil?

          without_ids, with_ids = params.partition { |image_params| image_params['id'].blank? }

          without_ids.each do |image_params|
            image = Image.create!(image: image_params['file'], user: user)
            ImagesRelation.create!(image: image, relation: cite, user: user)
            ImagesRelation.create!(image: image, relation: entity, user: user)
          end

          images = Image.find(with_ids.map { |item| item['id'] })

          with_ids.each do |image_params|
            matched_image = images.find { |item| item.id == image_params['id'] }

            if image_params['destroy']
              images_relation = ImagesRelation.find_by(image: matched_image, relation: entity)
              images_relation.destroy!
            else
              ImagesRelation.create!(image_id: image_params['id'], relation: cite, user: user)
            end
          end
        end
      end
    end
  end
end