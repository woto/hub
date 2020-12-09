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
require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
