# frozen_string_literal: true

# == Schema Information
#
# Table name: post_categories
#
#  id             :bigint           not null, primary key
#  ancestry       :string
#  ancestry_depth :integer          default(0)
#  posts_count    :integer          default(0), not null
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

describe PostCategory, type: :model, responsible: :admin do
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
    let(:parent) { create(:post_category, realm: create(:realm, kind: :post)) }

    context 'when child belongs to another realm' do
      subject { build(:post_category, parent: parent, realm: create(:realm, kind: :post)) }

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
    let(:parent) { create(:post_category, realm: realm) }

    context 'when parent has posts' do
      before do
        create_list(:post, 1, post_category: parent)
      end

      it { is_expected.to be_invalid }
    end

    context 'when parent does not have posts' do
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
        result = GlobalHelper.elastic_client.get({ index: Elastic::IndexName.post_categories, id: subject.id })
        result['_source']['leaf']
      }.from(true).to(false)
    end
  end

  describe '.leaves' do
    subject { described_class.leaves }

    let(:realm) { create(:realm) }
    let(:post_category1) { create(:post_category, realm: realm) }
    let(:post_category2) { create(:post_category, parent: post_category1, realm: realm) }
    let(:post_category3) { create(:post_category, parent: post_category2, realm: realm) }

    it { is_expected.to contain_exactly(post_category3) }
  end

  describe '#validate_childless' do
    let!(:parent_category) { create(:post_category) }

    before do
      create(:post_category, parent: parent_category, realm: parent_category.realm)
    end

    it 'does not allow to remove post category with child post category' do
      expect do
        parent_category.destroy
      end.not_to change(described_class, :count)

      expect(parent_category.errors.details).to eq({ base: [{ error: :must_be_childless }] })
    end
  end
end
