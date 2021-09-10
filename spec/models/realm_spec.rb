# frozen_string_literal: true

# == Schema Information
#
# Table name: realms
#
#  id                    :bigint           not null, primary key
#  domain                :string           not null
#  kind                  :integer          not null
#  locale                :string           not null
#  post_categories_count :integer          default(0), not null
#  posts_count           :integer          default(0), not null
#  title                 :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_realms_on_domain           (domain) UNIQUE
#  index_realms_on_locale_and_kind  (locale,kind) UNIQUE WHERE (kind <> 0)
#  index_realms_on_title            (title) UNIQUE
#
require 'rails_helper'

describe Realm, type: :model do
  it_behaves_like 'elasticable'
  it_behaves_like 'logidzable'

  describe 'fields' do
    it { is_expected.to define_enum_for(:kind) }
  end

  describe '#title' do
    before { create(:realm, title: 'title', kind: :post) }

    context 'when title is not unique' do
      let(:realm) { build(:realm, title: 'title') }

      it 'raises error' do
        expect { realm.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end

    context 'when title is unique' do
      let(:realm) { build(:realm, kind: :post) }

      it 'saves realm' do
        expect { realm.save(validate: false) }.not_to raise_error
      end
    end
  end

  describe '#domain' do
    before { create(:realm, domain: 'domain', kind: :post) }

    context 'when domain is not unique' do
      let(:realm) { build(:realm, domain: 'domain', kind: :post) }

      it 'raises error' do
        expect { realm.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end

    context 'when domain is unique' do
      let(:realm) { build(:realm, kind: :post) }

      it 'saves realm' do
        expect { realm.save(validate: false) }.not_to raise_error
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:post_categories) }
    it { is_expected.to have_many(:posts) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:kind) }
    it { is_expected.to validate_presence_of(:locale) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:domain) }
  end

  describe '#to_label' do
    subject { create(:realm) }

    it 'returns correct value' do
      expect(subject.to_label).to eq(subject.title)
    end
  end

  describe '#as_indexed_json' do
    subject { realm.as_indexed_json }

    let(:realm) { create(:realm) }

    it 'returns correct result' do
      expect(subject).to include(
        id: realm.id,
        domain: realm.domain,
        kind: realm.kind,
        locale: realm.locale,
        post_categories_count: realm.post_categories_count,
        posts_count: realm.posts_count,
        title: realm.title
      )
    end
  end

  describe '.pick' do
    let(:locale) { I18n.available_locales.sample.to_s }
    let(:kind) { described_class.kinds.keys.sample }

    context 'when only :kind and :locale are passed' do
      subject { described_class.pick(locale: locale, kind: kind) }

      it 'calls .find_or_create_by!' do
        expect { subject }.to change(described_class, :count)
        expect(described_class.last).to have_attributes(
          locale: locale,
          kind: kind,
          title: "Website: { kind: #{kind}, locale: #{locale} }",
          domain: "#{kind}-#{locale.downcase}.lvh.me"
        )
      end
    end

    context 'when all params are passed' do
      subject { described_class.pick(locale: locale, kind: kind, title: 'title', domain: 'domain') }

      it 'calls .find_or_create_by!' do
        expect { subject }.to change(described_class, :count)

        expect(described_class.last).to have_attributes(
          locale: locale,
          kind: kind,
          title: 'title',
          domain: 'domain'
        )
      end
    end
  end

  describe '[:kind, :locale] uniqueness validation' do
    subject { build(:realm, kind: kind, locale: :en) }

    before { create(:realm, kind: kind, locale: :en) }

    context 'when kind is :news?' do
      let(:kind) { :news }

      it { is_expected.to validate_uniqueness_of(:kind).scoped_to(:locale).ignoring_case_sensitivity }
    end

    context 'when kind is :help?' do
      let(:kind) { :help }

      it { is_expected.to validate_uniqueness_of(:kind).scoped_to(:locale).ignoring_case_sensitivity }
    end

    context 'when kind is :post?' do
      let(:kind) { :post }

      it { is_expected.to be_valid }
    end
  end

  describe 'unique [:locale, :kind] index' do
    subject { build(:realm, locale: locale, kind: kind).tap { |realm| realm.save(validate: false) } }

    before { create(:realm, locale: locale, kind: kind) }

    let(:locale) { :ru }

    context 'when #post?' do
      let(:kind) { :post }

      it 'allows to save with same kind and locale' do
        expect { subject }.not_to raise_error
      end
    end

    context 'with #news?' do
      let(:kind) { :news }

      it 'does not allow to save with same kind and locale' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end

    context 'with #help?' do
      let(:kind) { :help }

      it 'does not allow to save with same kind and locale' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
