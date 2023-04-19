# frozen_string_literal: true

require 'rails_helper'

shared_examples '#image_hash' do |width:, height:|
  it 'returns correct image hash' do
    expect(GlobalHelper.image_hash(images_relations, %w[50]).first).to include(
      "height" => height,
      "width" => width,
      "original" => be_a(String),
      "images" => match(
        '50' => be_a(String)
      )
    )
  end
end
