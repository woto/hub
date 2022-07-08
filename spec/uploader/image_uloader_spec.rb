# frozen_string_literal: true

require 'rails_helper'

describe ImageUploader do
  shared_examples 'not raise exception on derivation process' do
    let(:shrine_image)       { image.image }
    let(:shrine_derivatives) { image.image_derivatives }
    let(:image) { Image.create(image: File.open("spec/fixtures/files/formats/#{file_name}", 'rb')) }

    it 'processes derivation' do
      expect { shrine_image.derivation(:thumbnail, 100, 100).processed }.not_to raise_error
    end
  end

  context 'when file_name is gif.gif' do
    let(:file_name) { 'gif.gif' }

    it_behaves_like 'not raise exception on derivation process'
  end

  context 'when file_name is ico.ico' do
    let(:file_name) { 'ico.ico' }

    it_behaves_like 'not raise exception on derivation process'
  end

  context 'when file_name is png.png' do
    let(:file_name) { 'png.png' }

    it_behaves_like 'not raise exception on derivation process'
  end

  context 'when file_name is svg.svg' do
    let(:file_name) { 'svg.svg' }

    it_behaves_like 'not raise exception on derivation process'
  end

  context 'when file_name is webp.webp' do
    let(:file_name) { 'webp.webp' }

    it_behaves_like 'not raise exception on derivation process'
  end
end
