# frozen_string_literal: true

# == Schema Information
#
# Table name: entities
#
#  id             :bigint           not null, primary key
#  image_data     :jsonb
#  lookups_count  :integer          default(0), not null
#  mentions_count :integer          default(0), not null
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_entities_on_image_data  (image_data) USING gin
#  index_entities_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Entity, type: :model do
  it_behaves_like 'elasticable'
  it_behaves_like 'logidzable'

  describe 'associations' do
    it { is_expected.to belong_to(:user).counter_cache(true) }
    it { is_expected.to have_many(:entities_mentions).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:mentions).through(:entities_mentions).counter_cache(:mentions_count) }
    it { is_expected.to have_many(:lookups).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  it { is_expected.to accept_nested_attributes_for(:lookups).allow_destroy(true) }

  describe '#image' do
    subject { create(:entity, image: ShrineImage.uploaded_image) }

    it 'processes image' do
      expect(subject.image).to be_a(ImageUploader::UploadedFile)
    end
  end

  describe '#as_indexed_json', responsible: :user do
    subject { entity.as_indexed_json }

    around do |example|
      freeze_time do
        example.run
      end
    end

    let(:entity) do
      create(:entity,
             mentions: [create(:mention)],
             image: ShrineImage.uploaded_image)
    end

    it 'returns correct result' do
      expect(subject).to match(
        id: entity.id,
        lookups: entity.lookups.map(&:to_label),
        lookups_count: entity.lookups_count,
        title: entity.title,
        image: be_a(String),
        user_id: entity.user_id,
        mentions_count: entity.mentions_count,
        created_at: Time.current,
        updated_at: Time.current
      )
    end
  end

  describe '#to_label' do
    subject { create(:entity, title: 'entity') }

    specify do
      expect(subject.to_label).to eq('entity')
    end
  end
end
