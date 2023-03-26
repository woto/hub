# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id          :bigint           not null, primary key
#  image_data  :jsonb
#  youtube_url :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
# Indexes
#
#  index_images_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

describe Image do

  describe 'associations' do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to have_many(:images_relations) }
    it { is_expected.to have_many(:entities).through(:images_relations).source(:relation) }
    it { is_expected.to have_many(:mentions).through(:images_relations).source(:relation) }
    it { is_expected.to have_many(:cites).through(:images_relations).source(:relation) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:image) }
  end

  describe 'factory' do
    subject(:image) { create(:entities_entity) }

    it { is_expected.to be_persisted }
  end
end
