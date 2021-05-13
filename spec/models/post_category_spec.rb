# frozen_string_literal: true

# == Schema Information
#
# Table name: post_categories
#
#  id             :bigint           not null, primary key
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#  posts_count    :integer          default(0)
#  priority       :integer          default(0), not null
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  realm_id       :bigint           not null
#
# Indexes
#
#  index_post_categories_on_ancestry  (ancestry)
#  index_post_categories_on_realm_id  (realm_id)
#
# Foreign Keys
#
#  fk_rails_...  (realm_id => realms.id)
#
require 'rails_helper'

describe PostCategory, type: :model do
  it_behaves_like 'elasticable'
  it_behaves_like 'logidzable'

  describe 'associations' do
    it { is_expected.to belong_to(:realm).counter_cache(true).touch(true) }
    it { is_expected.to have_many(:posts) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  it { is_expected.to have_db_column(:ancestry) }
  it { is_expected.to have_db_column(:ancestry_depth) }

  describe '#check_same_realms' do
    let(:parent) { create(:post_category) }

    context 'when child belongs to another realm' do
      subject { build(:post_category, parent: parent) }

      it 'is invalid' do
        expect(subject).to be_invalid
        expect(subject.errors.details).to eq({ realm_id: [{ error: 'must have same realm_id' }] })
      end
    end

    context 'when child belongs to same realm' do
      subject { build(:post_category, parent: parent, realm: parent.realm) }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end
  end

  describe '#check_parent_does_not_have_posts' do
    subject { build(:post_category, parent: parent, realm: realm) }

    let(:realm) { create(:realm) }
    let(:parent) do
      Current.set(responsible: create(:user, role: :admin)) do
        create(:post_category, posts: posts, realm: realm)
      end
    end

    context 'when parent has posts' do
      let(:posts) { create_list(:post, 1) }

      it { is_expected.to be_invalid }
    end

    context 'when parent does not have posts' do
      let(:posts) { [] }

      it { is_expected.to be_valid }
    end
  end

  describe '#as_indexed_json' do
    subject { post_category.as_indexed_json }

    let(:realm) { create(:realm) }
    let(:parent) { create(:post_category, realm: realm) }
    let(:post_category) { create(:post_category, parent: parent, realm: realm) }

    it 'returns correct result' do
      expect(subject).to include(
        id: post_category.id,
        title: post_category.title,
        path: [parent.title],
        realm_id: realm.id,
        realm_title: realm.title,
        realm_locale: realm.locale,
        realm_kind: realm.kind,
        leaf: true,
        priority: post_category.priority,
        ancestry_depth: 1,
        posts_count: 0
      )
    end
  end

  describe '#touch_parent' do
    subject { create(:post_category, realm: realm) }

    let(:realm) { create(:realm) }

    it 'touches parent and makes it non-leaf' do
      expect do
        create(:post_category, title: 'Дочерняя категория', parent: subject, realm: realm)
      end.to change {
        result = elastic_client.get({ index: Elastic::IndexName.post_categories, id: subject.id })
        result['_source']['leaf']
      }.from(true).to(false)
    end
  end
end
