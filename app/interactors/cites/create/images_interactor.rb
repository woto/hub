# frozen_string_literal: true

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
              optional(:dark)
              optional(:json)
            end
          end
        end
      end

      def call
        return if params.nil?

        params.each_with_index do |image_params, index|
          if image_params['id'].present?
            process_image_with_id(image_params, index)
          else
            process_image_without_id(image_params, index)
          end
        end
      end

      def process_image_with_id(image_params, index)
        image = Image.find(image_params['id'])
        images_relation = ImagesRelation.find_by!(image:, relation: entity)

        if image_params['destroy']
          # TODO: check
          # return unless images_relation
          images_relation.destroy!
        else
          ImagesRelation.create!(image:, order: index, relation: cite, dark: image_params['dark'], user:)
          images_relation.update!(order: index, dark: image_params['dark'])
        end
      end

      def process_image_without_id(image_params, index)
        # TODO: check
        # return unless image_params['json']
        return if image_params['destroy']

        image = Image.create!(image: image_params['json'], user:)
        ImagesRelation.create!(image:, order: index, relation: cite, dark: image_params['dark'], user:)
        ImagesRelation.create!(image:, order: index, relation: entity, dark: image_params['dark'], user:)
      end
    end
  end
end
