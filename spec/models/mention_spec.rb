# frozen_string_literal: true

# == Schema Information
#
# Table name: mentions
#
#  id             :bigint           not null, primary key
#  entities_count :integer          default(0), not null
#  html           :text
#  image_data     :jsonb
#  kinds          :jsonb            not null
#  published_at   :datetime
#  sentiment      :integer          not null
#  text           :text
#  title          :string
#  topics_count   :integer          default(0), not null
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
    it { is_expected.to have_many(:entities_mentions).dependent(:destroy) }
    it { is_expected.to have_many(:entities).through(:entities_mentions).counter_cache(:entities_count) }
    it { is_expected.to have_many(:mentions_topics).dependent(:destroy) }
    it { is_expected.to have_many(:topics).through(:mentions_topics).counter_cache(:topics_count) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:entities) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:topics) }
    it { is_expected.to validate_presence_of(:sentiment) }
    it { is_expected.to validate_presence_of(:kinds) }

    # https://github.com/thoughtbot/shoulda-matchers/issues/1007
    # it { is_expected.to validate_length_of(:topics).is_at_least(1) }
    describe '#topics minimal length' do
      subject { build(:mention, topics: []).tap(&:valid?).errors.details }

      it { is_expected.to eq({ topics: [{ error: :blank }, { count: 1, error: :too_short }] }) }
    end

    # https://github.com/thoughtbot/shoulda-matchers/issues/1007
    # it { is_expected.to validate_length_of(:entities).is_at_least(1) }
    describe '#entities minimal length' do
      subject { build(:mention, entities: []).tap(&:valid?).errors.details }

      it { is_expected.to eq({ entities: [{ error: :blank }, { count: 1, error: :too_short }] }) }
    end

    describe '#validate_kinds_length' do
      subject { build(:mention, kinds: kinds) }

      context 'when kinds is empty' do
        let(:kinds) { [] }

        specify do
          expect(subject).to be_invalid
          expect(subject.errors.details).to eq({ kinds: [{ error: :blank }, { error: :inclusion }] })
        end
      end
    end

    describe '#kinds' do
      context 'when kinds is valid' do
        subject { build(:mention, kinds: %w[text image video]) }

        specify do
          expect(subject).to be_valid
        end
      end
    end

    describe '#validate_kinds_keys' do
      subject { build(:mention, kinds: kinds) }

      context 'when kinds includes wrong key' do
        let(:kinds) { %w[fake] }

        specify do
          expect(subject).to be_invalid
          expect(subject.errors.details).to eq({ kinds: [{ error: :inclusion }] })
        end
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
        topics: mention.topics.map(&:to_label),
        url: mention.url,
        title: nil,
        user_id: mention.user_id,
        image: include(
          :height,
          :width,
          image_original: be_a(String),
          image_thumbnail: be_a(String)
        ),
        entity_ids: mention.entity_ids,
        entities: mention.entities.map(&:title),
        created_at: Time.current,
        updated_at: Time.current
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
      expect(subject.topics.count).to eq(1)
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
    subject! { create(:mention) }

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

    def do_the_action
      subject.update(topics_attributes: params)
    end

    context 'when does not pass topic1 and topic1 is linked to the mention' do
      let(:params) { [topic2.title] }

      it 'unlinks topic1 but does not remove it' do
        do_the_action
        expect(subject.topics).to contain_exactly(topic2)
        expect(topic1.reload).not_to be_nil
      end
    end

    context 'when passed new topic which is not exists yet' do
      let(:params) { [topic1.title, topic2.title, 'new topic'] }

      it 'creates new linked topic' do
        expect do
          do_the_action
          expect(subject.topics).to contain_exactly(topic1, topic2, Topic.find_by(title: 'new topic'))
        end.to change(Topic, :count).by(1)
      end
    end

    context 'when passed topic is not liked yet to the mention' do
      let!(:topic) { create(:topic) }

      let(:params) { [topic1.title, topic2.title, topic.title] }

      it 'links topic to the mention' do
        expect do
          do_the_action
          expect(subject.topics).to contain_exactly(topic1, topic2, topic)
        end.not_to change(Topic, :count)
      end
    end

    context 'when passed topics already linked to the mention' do
      let(:params) { [topic1.title, topic2.title] }

      it 'does not relink it again' do
        expect do
          do_the_action
          expect(subject.topics).to contain_exactly(topic1, topic2)
        end.not_to change(Topic, :count)
      end
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
end
