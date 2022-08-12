# frozen_string_literal: true

class MoveMentionImageDataToImagesRelation < ActiveRecord::Migration[6.1]
  def change
    Mention.find_each do |mention|
      if mention.image_data
        image = Image.create!(image_data: mention.image_data)
        ImagesRelation.create!(image: image, relation: mention)
      end
    end
  end
end
