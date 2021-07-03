# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  amount           :decimal(, )      not null
#  currency         :integer          not null
#  extra_options    :jsonb
#  priority         :integer          default(0), not null
#  published_at     :datetime
#  status           :integer          not null
#  tags             :jsonb
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exchange_rate_id :bigint           not null
#  post_category_id :bigint           not null
#  realm_id         :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_posts_on_exchange_rate_id  (exchange_rate_id)
#  index_posts_on_post_category_id  (post_category_id)
#  index_posts_on_realm_id          (realm_id)
#  index_posts_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (exchange_rate_id => exchange_rates.id)
#  fk_rails_...  (post_category_id => post_categories.id)
#  fk_rails_...  (realm_id => realms.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

describe Post, type: :model do
  it_behaves_like 'elasticable'
  it_behaves_like 'logidzable'

  it { is_expected.to define_enum_for(:currency).with_values(GlobalHelper.currencies_table) }
  it { is_expected.to have_many_attached(:images) }
  it { is_expected.to have_rich_text(:body) }
  it { is_expected.to have_rich_text(:intro) }

  specify do
    statuses = %i[draft_post pending_post approved_post rejected_post accrued_post canceled_post removed_post]
    expect(subject).to define_enum_for(:status).with_values(statuses)
  end

  describe 'associations' do
    it { is_expected.to belong_to(:realm) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post_category) }
    it { is_expected.to belong_to(:exchange_rate).without_validating_presence }
    it { is_expected.to have_many(:transactions) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:tags) }
    it { is_expected.to validate_length_of(:tags).is_at_least(2) }

    context 'when currency is included in `currencies_table`, but is not included in `available_currencies`' do
      subject { build(:post, currency: :eek) }

      it 'includes `:inclusion` error in `currency` attribute' do
        expect(subject).to be_invalid
        expect(subject.errors.details).to eq(currency: [{ error: :inclusion, value: 'eek' }])
      end
    end

    describe '#published_at' do
      it { is_expected.to validate_presence_of(:published_at).allow_nil }

      context 'when post has :accrued_post status' do
        subject { build(:post, status: :accrued_post) }

        it { is_expected.to validate_presence_of(:published_at) }
      end
    end
  end

  describe '#check_min_intro_length' do
    it { is_expected.to allow_value('text').for(:intro) }
    it { is_expected.to allow_value(nil).for(:intro) }

    context 'when post has :accrued_post status' do
      subject { build(:post, status: :accrued_post, intro: '') }

      it { is_expected.not_to allow_value(nil).for(:intro) }
    end
  end

  describe '#check_min_body_length' do
    it { is_expected.to allow_value('text').for(:body) }
    it { is_expected.not_to allow_value(nil).for(:body) }
  end

  describe 'scopes' do
    describe '.news' do
      let(:post) { Current.set(responsible: create(:user)) { create(:post, realm_kind: :news) } }

      before do
        Current.set(responsible: create(:user)) { create(:post, realm_kind: :post) }
        Current.set(responsible: create(:user)) { create(:post, realm_kind: :help) }
      end

      it 'returns posts with news realm kind' do
        expect(described_class.news).to contain_exactly(post)
      end
    end
  end

  describe '#as_indexed_json' do
    around(:each) do |example|
      freeze_time do
        example.run
      end
    end

    subject { Current.set(responsible: create(:user)) { post.as_indexed_json } }

    let(:realm) { create(:realm) }
    let(:parent_category) { create(:post_category, realm: realm) }
    let(:child_category) { create(:post_category, realm: realm, parent: parent_category) }
    let(:post) { create(:post, post_category: child_category) }

    it 'returns correct result' do
      expect(subject).to match(
        id: post.id,
        realm_id: post.realm.id,
        realm_title: post.realm.title,
        realm_locale: post.realm.locale,
        realm_kind: post.realm.kind,
        realm_domain: post.realm.domain,
        status: post.status,
        title: post.title,
        post_category_id: post.post_category_id,
        post_category_title: post.post_category.title,
        tags: post.tags,
        published_at: post.published_at&.utc,
        user_id: post.user_id,
        intro: post.intro.to_s,
        body: post.body.to_s,
        amount: post.amount,
        currency: post.currency,
        priority: post.priority,
        post_category_id_0: post.post_category.parent.id,
        post_category_id_1: post.post_category.id,
        post_category_ids: [post.post_category.parent.id, post.post_category.id],
        created_at: Time.current,
        updated_at: Time.current
      )
    end
  end

  describe '#set_exchange_rate' do
    let(:responsible) { create(:user) }

    context 'when post is not persisted' do
      let(:post) { Current.set(responsible: responsible) { build(:post) } }

      it 'picks new ExchangeRate with today date and assign it to the post' do
        expect(ExchangeRate).to receive(:pick).with(nil).and_call_original
        expect(post.exchange_rate).to be_nil
        expect(post).to be_valid
        expect(post.exchange_rate).to be_a(ExchangeRate)
      end
    end

    context 'when post is persisted' do
      let(:post) { Current.set(responsible: responsible) { create(:post) } }

      it 'picks same ExchangeRate according to `created_at` and assign it to the post' do
        expect(ExchangeRate).to receive(:pick).with(post.created_at).and_call_original
        post.exchange_rate = nil
        expect(post).to be_valid
        expect(post.exchange_rate).to be_a(ExchangeRate)
      end
    end
  end

  describe '#set_amount' do
    subject { build(:post, **params) }

    context 'when `body` is empty' do
      let(:params) { { body: "\n[200x200.jpg]\n" } }

      it 'blames on `body`' do
        expect(subject).to be_invalid
        expect(subject.errors.details).to eq(body: [{ count: 1, error: :too_short }])
        expect(subject.amount).to be_zero
      end
    end

    context 'when `currency` is not set' do
      let(:params) { { currency: nil } }

      it 'blames on `currency`' do
        expect(subject).to be_invalid
        expect(subject.errors.details).to eq(currency: [{ error: :inclusion, value: nil }])
        expect(subject.amount).to be_zero
      end
    end

    context 'when `rate` is zero' do
      let(:params) { { currency: :ghc } }

      it 'blames on `currency`' do
        freeze_time do
          date = Time.current.utc.to_date
          expect(subject).to be_invalid
          expect(subject.errors.details).to eq(currency: [{ currency: 'ghc', date: date, error: :no_rate }])
          expect(subject.amount).to be_zero
        end
      end
    end

    context 'when all params needed to calculate amount is present' do
      let(:params) { { body: body, currency: currency } }
      let(:body) { Faker::Lorem.word }
      let(:rate) { Faker::Number.decimal(l_digits: 6, r_digits: 6) }
      let(:currency) { 'ghc' }

      it 'sets `amount`' do
        expect(Rails.configuration.exchange_rates).to receive(:currencies).and_return([{ key: currency, value: rate }])
        expect(subject).to be_valid
        expect(subject.amount).to eq((rate * body.length))
      end
    end
  end

  describe '#check_post_category_realm', responsible: :user do
    subject { build(:post, post_category: post_category, realm: realm) }

    let(:realm) { create(:realm) }
    let(:post_category) { create(:post_category) }

    it 'blames on `post_category`' do
      expect(subject).to be_invalid
      expect(subject.errors.details).to eq(post_category: [{ error: :realms_differ }])
    end
  end

  describe '#check_post_category_is_leaf' do
    let(:realm) { create(:realm) }
    let!(:parent) { create(:post_category, realm: realm) }
    let!(:child) { create(:post_category, realm: realm, parent: parent) }

    context 'when `post_category` is not leaf' do
      subject { Current.set(responsible: create(:user, role: :admin)) { build(:post, post_category: parent) } }

      it 'blames on `post_category`' do
        expect(subject).to be_invalid
        expect(subject.errors.details).to eq(post_category: [{ error: :must_be_leaf }])
      end
    end

    context 'when `post_category` is leaf' do
      subject { Current.set(responsible: create(:user, role: :admin)) { build(:post, post_category: child) } }

      it { is_expected.to be_valid }
    end
  end

  describe '#check_currency_value' do
    context 'when currency value missing in exchange_rate' do
      subject { build(:post, currency: :ghc) }

      it 'returns `:no_rate` error' do
        expect(subject).to be_invalid
        freeze_time do
          date = Time.current.utc.to_date
          expect(subject.errors.details).to eq(currency: [{ currency: 'ghc', date: date, error: :no_rate }])
        end
      end
    end
  end

  describe '#create_transactions' do
    context 'when post is not persisted yet' do
      subject { build(:post, status: described_class.statuses.keys.sample) }

      it 'calls `Accounting::Main::ChangeStatus` with correct params' do
        expect(Accounting::Main::ChangeStatus).to receive(:call).with(record: subject)
        expect(subject.save).to be_truthy
      end
    end

    context 'when post already persisted' do
      subject! { Current.set(responsible: user) { create(:post, user: user) } }

      let(:user) { create(:user) }
      let(:status) { described_class.statuses.keys.sample }

      it 'calls `Accounting::Main::ChangeStatus` with correct params' do
        expect(Accounting::Main::ChangeStatus).to receive(:call).with(record: subject)
        expect(subject.update(status: status)).to be_truthy
      end
    end

    context 'when `ActiveRecord::ActiveRecordError` occurs' do
      it 're-raises error to break transaction' do
        expect(Accounting::Main::ChangeStatus).to receive(:call).and_raise(ActiveRecord::ActiveRecordError, 'aaa')
        expect(Rails.logger).to receive(:error)
        expect { create(:post) }.to raise_error(StandardError, 'aaa')
      end
    end
  end

  describe '#stop_destroy', responsible: :admin do
    context 'when post is trying to destroy' do
      let(:post) { create(:post) }

      it 'returns validation error' do
        expect(post.destroy).to be_falsey
        expect(post).to be_persisted
        expect(post.errors.details).to eq({ base: [{ error: :undestroyable }] })
        expect(post).to be_valid
      end
    end
  end

  context 'when responsible is not set' do
    it 'raises error' do
      expect { create(:post) }.to raise_error(Pundit::NotAuthorizedError, 'responsible is not set')
    end
  end
end
