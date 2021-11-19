# frozen_string_literal: true

# == Schema Information
#
# Table name: exchange_rates
#
#  id            :bigint           not null, primary key
#  currencies    :jsonb            not null
#  date          :date             not null
#  extra_options :jsonb            not null
#  posts_count   :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

describe ExchangeRate, type: :model do
  it_behaves_like 'logidzable'
  it_behaves_like 'elasticable'

  describe 'validations' do
    subject { create(:exchange_rate) }

    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_uniqueness_of(:date) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:posts).dependent(:restrict_with_error) }
  end

  describe 'factory' do
    subject { build(:exchange_rate) }

    it { is_expected.to be_valid }
  end

  describe '#set_currencies_and_extra_options' do
    context 'when `Rails.configuration.exchange_rates.extra_options` is invalid' do
      let(:subject) { build(:exchange_rate) }

      it 'is contain error in `extra_options` attribute' do
        expect(Rails.configuration.exchange_rates).to receive(:extra_options).and_return([])
        expect(subject).to be_invalid
        expect(subject.errors.details[:extra_options]).to contain_exactly({ error: :invalid })
      end
    end

    context 'when `Rails.configuration.exchange_rates.currencies` is invalid' do
      let(:subject) { build(:exchange_rate) }

      it 'is contain error in `currencies` attribute' do
        expect(Rails.configuration.exchange_rates).to receive(:currencies).and_return([])
        expect(subject).to be_invalid
        expect(subject.errors.details[:currencies]).to contain_exactly({ error: :invalid })
      end
    end

    context 'when `currencies` is nil' do
      subject { build(:exchange_rate, currencies: nil) }

      it { is_expected.to be_valid }
    end

    context 'when `extra_options` is nil' do
      subject { build(:exchange_rate, extra_options: nil) }

      it { is_expected.to be_valid }
    end
  end

  describe '#get_currency_value' do
    subject { create(:exchange_rate).get_currency_value(currency) }

    context 'when currency is found' do
      let(:value) { Faker::Number.decimal }
      let(:currency) { Faker::Alphanumeric.alpha(number: 3) }

      it 'returns currency value' do
        expect(Rails.configuration.exchange_rates).to receive(:currencies).and_return([{ key: currency, value: value }])
        expect(subject).to eq(value.to_d)
      end
    end

    context 'when currency is not found' do
      let(:currency) { 'xxx' }

      it 'returns zero' do
        expect(subject).to eq(0)
      end
    end
  end

  describe '.pick' do
    context 'when date argument is passed' do
      it 'calls .find_or_create_by! with passed date' do
        date = 2.days.since.utc.to_date
        expect(described_class).to receive(:find_or_create_by!).with(date: date)
        described_class.pick(date)
      end
    end

    context 'when date argument is not passed' do
      it 'calls .find_or_create_by! with today date' do
        freeze_time do
          expect(described_class).to receive(:find_or_create_by!).with(date: Time.current.utc.to_date)
          described_class.pick
        end
      end
    end
  end

  describe '#currencies_contract' do
    context 'when `currencies` includes duplicates :key' do
      let(:key) { Faker::Alphanumeric.alpha(number: 3) }
      let(:currency) { { key: key, value: Faker::Number.decimal } }

      it 'returns error' do
        expect(Rails.configuration.exchange_rates).to receive(:currencies).and_return([currency, currency])
        expect(subject).to be_invalid
        expect(subject.errors.messages[:currencies]).to contain_exactly({ root: ['keys must be unique'] })
      end
    end
  end

  describe '#extra_options_contract' do
    context 'when `extra_options` includes duplicates :key' do
      let(:key) { Faker::Lorem.word }
      let(:extra_option) do
        { key: key, disabled: false, hint: 'z', priority: 1, type: 'check_boxes', values: [{ title: 'z', rate: 1.0 }] }
      end

      it 'returns error' do
        expect(Rails.configuration.exchange_rates).to receive(:extra_options).and_return([extra_option, extra_option])
        expect(subject).to be_invalid
        expect(subject.errors.messages[:extra_options]).to contain_exactly({ root: ['keys must be unique'] })
      end
    end
  end
end
