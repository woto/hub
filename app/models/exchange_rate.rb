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
class ExchangeRate < ApplicationRecord
  has_logidze ignore_log_data: true

  include Elasticable
  index_name "#{Rails.env}.exchange_rates"

  validates :date, presence: true
  validates :date, uniqueness: true

  validate :extra_options_contract
  validate :currencies_contract

  has_many :posts, dependent: :restrict_with_error

  before_validation :set_currencies_and_extra_options, on: :create

  def get_currency_value(currency)
    currencies.find { |c| c['key'] == currency }&.dig('value').to_d
  end

  def self.pick(date = nil)
    find_or_create_by!(date: (date || Time.current.utc).to_date)
  end

  private

  def set_currencies_and_extra_options
    self.currencies = Rails.configuration.exchange_rates.currencies
    self.extra_options = Rails.configuration.exchange_rates.extra_options
  end

  def extra_options_contract
    contract = CurrenciesStruct.new.call(root: currencies)
    errors.add(:currencies, :invalid, message: contract.errors.to_h) if contract.failure?
  end

  def currencies_contract
    contract = ExtraOptionsStruct.new.call(root: extra_options)
    errors.add(:extra_options, :invalid, message: contract.errors.to_h) if contract.failure?
  end

  class ExtraOptionsStruct < Dry::Validation::Contract
    params do
      config.validate_keys = true

      required(:root).value(:array, min_size?: 1).each do
        hash do
          required(:key).filled(:str?)
          required(:disabled).filled(:bool?)
          required(:type).filled(:str?)
          required(:priority).filled(:int?)
          required(:values).value(:array, min_size?: 1).each do
            hash do
              required(:title).filled(:str?)
              required(:rate).filled(:float?)
            end
          end
          required(:hint).filled(:str?)
        end
      end
    end

    rule(:root) do
      keys = values[:root].map { _1[:key] }
      key.failure('keys must be unique') if keys.uniq.length != keys.length
    end
  end

  class CurrenciesStruct < Dry::Validation::Contract
    params do
      config.validate_keys = true

      required(:root).value(:array, min_size?: 1).each do
        hash do
          required(:key).filled(:str?)
          required(:value).filled(:float?)
        end
      end
    end

    rule(:root) do
      keys = values[:root].map { _1[:key] }
      key.failure('keys must be unique') if keys.uniq.length != keys.length
    end
  end
end
