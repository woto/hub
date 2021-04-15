require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#on_image_error_load' do
    it 'returns placeholder image' do
      expect(helper.on_image_error_load).to match(/image-not-found/)
    end
  end
end
