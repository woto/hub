# frozen_string_literal: true

require 'rails_helper'

shared_examples '#image_hash' do |width:, height:|
  it 'returns correct image hash' do
    expect(subject.image_hash).to match(
      height: height,
      width: width,
      original: be_a(String),
      thumbnails: match(
        '50' => be_a(String),
        '100' => be_a(String),
        '200' => be_a(String),
        '300' => be_a(String),
        '500' => be_a(String),
        '1000' => be_a(String)
      )
    )
  end
end
