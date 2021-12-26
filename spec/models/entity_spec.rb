# frozen_string_literal: true

# == Schema Information
#
# Table name: entities
#
#  id                :bigint           not null, primary key
#  image_data        :jsonb
#  intro             :text
#  lookups_count     :integer          default(0), not null
#  mentions_count    :integer          default(0), not null
#  metadata_iframely :jsonb
#  metadata_yandex   :jsonb
#  title             :string
#  topics_count      :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  hostname_id       :bigint
#  user_id           :bigint           not null
#
# Indexes
#
#  index_entities_on_hostname_id  (hostname_id)
#  index_entities_on_image_data   (image_data) USING gin
#  index_entities_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (hostname_id => hostnames.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Entity, type: :model do
  it_behaves_like 'elasticable'
  it_behaves_like 'logidzable'

  describe 'associations' do
    it { is_expected.to belong_to(:user).counter_cache(true) }
    it { is_expected.to belong_to(:hostname).counter_cache(true) }

    it { is_expected.to have_many(:entities_mentions).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:mentions).through(:entities_mentions).counter_cache(:mentions_count) }

    it { is_expected.to have_many(:lookups).dependent(:destroy) }

    it { is_expected.to have_many(:entities_topics).dependent(:destroy) }
    it { is_expected.to have_many(:topics).through(:entities_topics) }

    specify do
      expect(subject).to have_many(:children_entities).dependent(:destroy).class_name('EntitiesEntity')
                                                      .with_foreign_key('parent_id').inverse_of(:parent)
    end

    specify do
      expect(subject).to have_many(:children).class_name('Entity').through(:children_entities)
                                             .source(:child).inverse_of(:parents)
    end

    specify do
      expect(subject).to have_many(:parents_entities).dependent(:destroy).class_name('EntitiesEntity')
                                                     .with_foreign_key('child_id').inverse_of(:child)
    end

    specify do
      expect(subject).to have_many(:parents).class_name('Entity').through(:parents_entities)
                                            .source(:parent).inverse_of(:children)
    end
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
      create(:entity, title: "https://#{hostname.title}", topics: [topic], lookups: [lookup],
                      image: ShrineImage.uploaded_image)
    end
    let(:lookup) { create(:lookup, title: 'lookup title') }
    let(:topic) { create(:topic, title: 'topic title') }
    let(:hostname) { create(:hostname) }

    before do
      create(:mention, entities: [entity])
    end

    it 'returns correct result' do
      expect(subject).to match(
        id: entity.id,
        lookups: ['lookup title'],
        lookups_count: 1,
        topics: ['topic title'],
        topics_count: 1,
        title: entity.title,
        hostname: hostname.title,
        intro: nil,
        image: be_a(Hash),
        user_id: entity.user_id,
        mentions_count: 1,
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

  describe '#topics_attributes=' do
    subject! { create(:entity, topics: [topic1, topic2]) }

    let(:topic1) { create(:topic) }
    let(:topic2) { create(:topic) }

    it_behaves_like '#topics_attributes='
  end

  describe '#image_hash' do
    context 'when image is present' do
      subject! { create(:entity, image_data: image_data) }

      let(:image_data) do
        ImageUploader.upload(File.open('spec/fixtures/files/jessa_rhodes.jpg', 'rb'), :store).as_json
      end

      it_behaves_like '#image_hash', width: 552, height: 552
    end

    context 'when image is absent' do
      it_behaves_like '#image_hash', width: 50, height: 50
    end
  end

  describe '#strip_title' do
    subject { build(:entity, title: " hello \n ") }

    it 'strips title' do
      subject.save!
      expect(subject.reload.title).to eq('hello')
    end
  end

  context 'when entity has parents and children' do
    let(:parent) { create(:entity) }
    let(:child) { create(:entity) }
    let!(:entity) { create(:entity, parents: [parent], children: [child]) }

    it 'stores correctly' do
      expect(entity.parents).to contain_exactly(parent)
      expect(entity.children).to contain_exactly(child)
    end

    context 'when trying to remove self' do
      def destroy_entity
        entity.destroy
      end

      it 'removes self' do
        destroy_entity
        expect { entity.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'does not remove parents or children' do
        destroy_entity
        expect(parent.reload).to be_persisted
        expect(child.reload).to be_persisted
      end

      it 'removes two entities_entities' do
        expect { destroy_entity }.to change(EntitiesEntity, :count).by(-2)
      end
    end
  end

  describe '#fill_hostname' do
    it_behaves_like 'shared_hostname_new' do
      subject { build(:entity) }
    end

    it_behaves_like 'shared_hostname_existed' do
      subject { build(:entity, title: "https://#{hostname.title}/foo") }

      let!(:hostname) { create(:hostname) }
    end
  end
end
