# frozen_string_literal: true

class MoveEntityImageDataToImagesRelations < ActiveRecord::Migration[6.1]
  def change
    Entity.find_each do |entity|
      if entity.image_data
        image = Image.create!(image_data: entity.image_data)
        ImagesRelation.create!(image: image, relation: entity)
      end
    end
  end
end
