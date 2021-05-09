# frozen_string_literal: true

# == Schema Information
#
# Table name: exchange_rates
#
#  id            :bigint           not null, primary key
#  currencies    :jsonb            not null
#  date          :date             not null
#  extra_options :jsonb            not null
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

  describe '#set_currencies_and_extra_options' do
    context 'when Rails.configuration.exchange_rates.extra_options is invalid' do
      let(:subject) { build(:exchange_rate) }

      it 'is contain error in extra_options field' do
        expect(Rails.configuration.exchange_rates).to receive(:extra_options).and_return([])
        expect(subject).to be_invalid
        expect(subject.errors.details[:extra_options]).to contain_exactly({ error: :invalid })
      end
    end

    context 'when Rails.configuration.exchange_rates.currencies is invalid' do
      let(:subject) { build(:exchange_rate) }

      it 'is contain error in currencies field' do
        expect(Rails.configuration.exchange_rates).to receive(:currencies).and_return([])
        expect(subject).to be_invalid
        expect(subject.errors.details[:currencies]).to contain_exactly({ error: :invalid })
      end
    end

    context 'with non nil currencies and extra_options' do
      subject { build(:exchange_rate) }

      it { is_expected.to be_valid }
    end

    context 'when currencies is nil' do
      subject { build(:exchange_rate, currencies: nil) }

      it { is_expected.to be_valid }
    end

    context 'when extra_options is nil' do
      subject { build(:exchange_rate, extra_options: nil) }

      it { is_expected.to be_valid }
    end
  end

  describe '.pick' do
    context 'when date argument is passed' do
      it 'calls .find_or_create_by! with passed date' do
        date = 2.days.since.utc.to_date
        expect(ExchangeRate).to receive(:find_or_create_by!).with(date: date)
        ExchangeRate.pick(date)
      end
    end

    context 'when date argument is not passed' do
      it 'calls .find_or_create_by! with today date' do
        freeze_time do
          expect(ExchangeRate).to receive(:find_or_create_by!).with(date: Time.current.utc.to_date)
          ExchangeRate.pick
        end
      end
    end
  end
end
