# == Schema Information
#
# Table name: exchange_rates
#
#  id         :bigint           not null, primary key
#  currency   :integer          not null
#  date       :date             not null
#  value      :decimal(, )      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ExchangeRate < ApplicationRecord
  enum currency: Rails.configuration.global[:currencies]
  validates :currency, :date, :value, presence: true
  validates :date, uniqueness: true
end
