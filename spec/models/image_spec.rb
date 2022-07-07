# frozen_string_literal: true

require 'rails_helper'

describe Image do
  describe 'validations' do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to validate_presence_of(:image) }
  end

  describe 'factory' do
    subject(:image) { create(:entities_entity) }

    it { is_expected.to be_persisted }
  end
end
