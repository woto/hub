# frozen_string_literal: true

# == Schema Information
#
# Table name: mentions
#
#  id             :bigint           not null, primary key
#  entities_count :integer          default(0), not null
#  image_data     :jsonb
#  kinds          :jsonb            not null
#  published_at   :datetime
#  sentiment      :integer          not null
#  tags           :jsonb
#  url            :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_mentions_on_image_data  (image_data) USING gin
#  index_mentions_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Mention, type: :model do
  it_behaves_like 'elasticable'
  it_behaves_like 'logidzable'

  it { is_expected.to define_enum_for(:sentiment).with_values(%w[positive negative unknown]) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:entities_mentions) }
    it { is_expected.to have_many(:entities).through(:entities_mentions) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:entities) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:tags) }
    it { is_expected.to validate_presence_of(:sentiment) }
    it { is_expected.to validate_presence_of(:kinds) }
    it { is_expected.to validate_length_of(:tags).is_at_least(2) }
    xit { is_expected.to validate_length_of(:entities).is_at_least(1) }

    describe '#validate_kinds' do
      subject { build(:mention, kinds: kinds) }

      context 'when kinds is valid' do
        let(:kinds) { %w[text image video] }

        it { is_expected.to be_valid }
      end

      context 'when kinds is not valid' do
        let(:kinds) { %w[fake] }

        it { is_expected.to be_invalid }
      end
    end

    context 'with responsible', responsible: :user do
      subject { build(:mention) }

      it { is_expected.to validate_uniqueness_of(:url) }
    end
  end

  describe '#image' do
    subject { create(:mention) }

    it 'processes image' do
      expect(subject.image).to be_a(ImageUploader::UploadedFile)
    end
  end

  describe '#as_indexed_json', responsible: :user do
    subject { mention.as_indexed_json }

    around do |example|
      freeze_time do
        example.run
      end
    end

    let(:mention) { create(:mention) }

    it 'returns correct result' do
      expect(subject).to match(
        id: mention.id,
        entities_count: mention.entities_count,
        kinds: mention.kinds,
        published_at: mention.published_at&.utc,
        sentiment: mention.sentiment,
        tags: mention.tags,
        url: mention.url,
        user_id: mention.user_id,
        image: be_a(String),
        entity_ids: mention.entity_ids,
        entities: mention.entities.map(&:title),
        created_at: Time.current,
        updated_at: Time.current
      )
    end
  end

  describe '#stop_destroy', responsible: :admin do
    context 'when mention is trying to destroy' do
      let(:mention) { create(:mention) }

      it 'returns validation error' do
        expect(mention.destroy).to be_falsey
        expect(mention).to be_persisted
        expect(mention.errors.details).to eq({ base: [{ error: :undestroyable }] })
        expect(mention).to be_valid
      end
    end
  end
end
