# frozen_string_literal: true

# == Schema Information
#
# Table name: mentions
#
#  id            :bigint           not null, primary key
#  canonical_url :text
#  html          :text
#  kinds         :jsonb            not null
#  published_at  :datetime
#  sentiments    :jsonb
#  title         :string
#  url           :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  hostname_id   :bigint
#  user_id       :bigint           not null
#
# Indexes
#
#  index_mentions_on_hostname_id  (hostname_id)
#  index_mentions_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (hostname_id => hostnames.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Mention, type: :model do
  it_behaves_like 'logidzable'

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:hostname).optional }
    it { is_expected.to have_many(:entities_mentions).dependent(:destroy) }
    it { is_expected.to have_many(:entities).through(:entities_mentions) }
    it { is_expected.to have_many(:topics_relations).dependent(:destroy) }
    it { is_expected.to have_many(:topics).through(:topics_relations) }
  end

  describe 'validations' do
    # it { is_expected.to validate_presence_of(:entities_mentions) }
    it { is_expected.to validate_presence_of(:url) }

    # https://github.com/thoughtbot/shoulda-matchers/issues/1007
    # it { is_expected.to validate_length_of(:entities).is_at_least(1) }
    xdescribe '#entities minimal length' do
      subject { build(:mention, entities: []).tap(&:valid?).errors.details }

      it { is_expected.to eq({ entities_mentions: [{ error: :blank }] }) }
    end

    context 'with responsible', responsible: :user do
      subject { build(:mention, hostname: create(:hostname)) }

      it { is_expected.to validate_uniqueness_of(:url) }
    end
  end

  describe '#image' do
    subject { create(:mention, image: create(:image)) }

    it 'processes image' do
      expect(subject.image.image).to be_a(ImageUploader::UploadedFile)
    end
  end

  describe '#as_indexed_json', responsible: :user do
    subject { mention.as_indexed_json }

    around do |example|
      freeze_time do
        example.run
      end
    end

    let(:mention) { create(:mention, title: 'mention title', url: "https://#{hostname.title}/foo") }
    let(:hostname) { create(:hostname) }

    it 'returns correct result' do
      expect(subject).to include(
        id: mention.id,
        published_at: mention.published_at&.utc,
        topics: mention.topics.map(&:to_label),
        # topics_count: mention.topics_count,
        url: mention.url,
        hostname: hostname.title,
        title: 'mention title',
        user_id: mention.user_id,
        # entity_ids: mention.entity_ids,
        entities: mention.entities_mentions.map do |entities_mention|
          {
            "created_at"=>entities_mention.created_at,
            "entity_id"=>entities_mention.entity_id,
            "id"=>entities_mention.id,
            "mention_date"=>nil,
            "mention_id"=>entities_mention.mention_id,
            "relevance"=>nil,
            "sentiment"=>nil,
          }
          # 'id' => entities_mention.entity.id,
          # 'is_main' => entities_mention.is_main,
          # 'title' => entities_mention.entity.title
        end,
        # entities_count: mention.entities_count,
        created_at: Time.current,
        updated_at: Time.current,
        slug: "#{mention.id}-mention-title"
      )
    end
  end

  xdescribe '#stop_destroy', responsible: :admin do
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

  describe 'factory' do
    subject! { create(:mention) }

    specify do
      expect(subject.topics.count).to eq(0)
    end

    specify do
      expect(subject.entities.count).to eq(1)
    end
  end

  context 'when removes mention with entity' do
    subject! { create(:mention) }

    it 'does not remove entity' do
      expect do
        expect do
          subject.destroy
        end.to change(described_class, :count).from(1).to(0)
      end.not_to change(Entity, :count).from(1)
    end
  end

  context 'when removes mention with topic' do
    subject! { create(:mention, topics: [create(:topic)]) }

    it 'does not remove topic' do
      expect do
        expect do
          subject.destroy
        end.to change(described_class, :count).from(1).to(0)
      end.not_to change(Topic, :count).from(1)
    end
  end

  describe '#topics_attributes=' do
    subject! { create(:mention, topics: [topic1, topic2]) }

    let(:topic1) { create(:topic) }
    let(:topic2) { create(:topic) }

    it_behaves_like '#topics_attributes='
  end

  describe '#image_hash' do
    context 'when image is present' do
      subject! { create(:mention, image: create(:image, image_data: image_data)) }

      let(:image_data) do
        ImageUploader.upload(File.open('spec/fixtures/files/jessa_rhodes.jpg', 'rb'), :store).as_json
      end

      it_behaves_like '#image_hash', width: 552, height: 552 do
        let(:images_relations) { [subject.image_relation] }
      end
    end

    xcontext 'when image is absent' do
      it_behaves_like '#image_hash', width: 50, height: 50
    end
  end

  describe '#strip_title' do
    subject { build(:mention, title: " hello \n ") }

    it 'strips title' do
      subject.save!
      expect(subject.reload.title).to eq('hello')
    end
  end

  describe '#strip_url' do
    subject { build(:mention, url: " http://example.com \n ") }

    it 'strips url' do
      subject.save!
      expect(subject.reload.url).to eq('http://example.com')
    end
  end

  describe '#fill_hostname' do
    let!(:entity) { create(:entity) }

    it_behaves_like 'shared_hostname_new' do
      subject { build(:mention, entities: [entity]) }
    end

    it_behaves_like 'shared_hostname_existed' do
      subject { build(:mention, url: "https://#{hostname.title}/foo", entities: [entity]) }

      let!(:hostname) { create(:hostname) }
    end
  end
end
