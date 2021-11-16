# frozen_string_literal: true

# == Schema Information
#
# Table name: mentions
#
#  id               :bigint           not null, primary key
#  amount           :decimal(, )      not null
#  currency         :integer          not null
#  entities_count   :integer          default(0), not null
#  kind             :integer          not null
#  published_at     :datetime
#  sentiment        :integer          not null
#  status           :integer          not null
#  tags             :jsonb
#  url              :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exchange_rate_id :bigint           not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_mentions_on_exchange_rate_id  (exchange_rate_id)
#  index_mentions_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (exchange_rate_id => exchange_rates.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Mention, type: :model do
  it_behaves_like 'elasticable'
  it_behaves_like 'logidzable'

  it { is_expected.to define_enum_for(:currency).with_values(GlobalHelper.currencies_table) }
  it { is_expected.to define_enum_for(:kind).with_values(%w[text image audio video]) }
  it { is_expected.to define_enum_for(:sentiment).with_values(%w[positive negative neutral]) }
  it { is_expected.to have_one_attached(:screenshot) }

  specify do
    statuses = %i[draft_mention pending_mention approved_mention rejected_mention accrued_mention canceled_mention
                  removed_mention]
    expect(subject).to define_enum_for(:status).with_values(statuses)
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:exchange_rate).without_validating_presence }
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_many(:entities_mentions) }
    it { is_expected.to have_many(:entities).through(:entities_mentions) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:entities) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:tags) }
    it { is_expected.to validate_presence_of(:sentiment) }
    it { is_expected.to validate_presence_of(:kind) }
    it { is_expected.to validate_length_of(:tags).is_at_least(2) }
    xit { is_expected.to validate_length_of(:entities).is_at_least(1) }

    # NOTE: exchange_rate and responsible are manually set because shoulda doesn't do this. Don't know why
    context 'with not null exchange_rate and responsible', responsible: :user do
      subject { build(:mention, exchange_rate: ExchangeRate.pick) }

      it { is_expected.to validate_uniqueness_of(:url) }
    end

    context 'when currency is included in `currencies_table`, but is not included in `available_currencies`' do
      subject { build(:mention, currency: :eek) }

      it 'includes `:inclusion` error in `currency` attribute' do
        expect(subject).to be_invalid
        expect(subject.errors.details).to eq(currency: [{ error: :inclusion, value: 'eek' }])
      end
    end
  end

  describe '#as_indexed_json', responsible: :user do
    subject { mention.as_indexed_json }

    around do |example|
      freeze_time do
        example.run
      end
    end

    let(:mention) { create(:mention, screenshot: Rack::Test::UploadedFile.new(file_fixture('avatar.png'))) }

    it 'returns correct result' do
      expect(subject).to match(
        id: mention.id,
        amount: mention.amount,
        currency: mention.currency,
        entities_count: mention.entities_count,
        kind: mention.kind,
        published_at: mention.published_at&.utc,
        sentiment: mention.sentiment,
        status: mention.status,
        tags: mention.tags,
        url: mention.url,
        exchange_rate_id: mention.exchange_rate_id,
        user_id: mention.user_id,
        screenshot: be_a(String),
        entity_ids: mention.entity_ids,
        entities: mention.entities.map(&:title),
        created_at: Time.current,
        updated_at: Time.current
      )
    end
  end

  describe '#set_exchange_rate', responsible: :user do
    context 'when mention is not persisted' do
      let(:mention) { build(:mention) }

      it 'picks new ExchangeRate with today date and assign it to the mention' do
        expect(ExchangeRate).to receive(:pick).with(nil).and_call_original
        expect(mention.exchange_rate).to be_nil
        expect(mention).to be_valid
        expect(mention.exchange_rate).to be_a(ExchangeRate)
      end
    end

    context 'when mention is persisted' do
      let(:mention) { create(:mention) }

      it 'picks same ExchangeRate according to `created_at` and assign it to the mention' do
        expect(ExchangeRate).to receive(:pick).with(mention.created_at).and_call_original
        mention.exchange_rate = nil
        expect(mention).to be_valid
        expect(mention.exchange_rate).to be_a(ExchangeRate)
      end
    end
  end

  describe 'currency and exchange_rate' do
    subject { build(:mention, **params, amount: 1) }

    context 'when `currency` is not set' do
      let(:params) { { currency: nil } }

      it 'blames on `currency`' do
        expect(subject).to be_invalid
        expect(subject.errors.details).to eq(currency: [{ error: :inclusion, value: nil }])
      end
    end

    context 'when `rate` is zero' do
      let(:params) { { currency: :ghc } }

      it 'blames on `currency`' do
        freeze_time do
          date = Time.current.utc.to_date
          expect(subject).to be_invalid
          expect(subject.errors.details).to eq(currency: [{ currency: 'ghc', date: date, error: :no_rate }])
        end
      end
    end
  end

  describe '#check_currency_value' do
    context 'when currency value missing in exchange_rate' do
      subject { build(:mention, currency: :ghc) }

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
    context 'when mention is not persisted yet' do
      subject { build(:mention) }

      it 'calls `Accounting::Main::ChangeStatus` with correct params' do
        expect(Accounting::Main::ChangeStatus).to receive(:call).with(record: subject)
        expect(subject.save).to be_truthy
      end
    end

    context 'when mention already persisted', responsible: :user do
      subject! { create(:mention) }

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
        expect { create(:mention) }.to raise_error(StandardError, 'aaa')
      end
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

  context 'when responsible is not set' do
    it 'raises error' do
      expect { create(:mention) }.to raise_error(Pundit::NotAuthorizedError, 'responsible is not set')
    end
  end
end
