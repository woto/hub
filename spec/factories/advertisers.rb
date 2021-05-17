# frozen_string_literal: true

# == Schema Information
#
# Table name: advertisers
#
#  id          :bigint           not null, primary key
#  feeds_count :integer          default(0)
#  is_active   :boolean          default(TRUE), not null
#  name        :string
#  network     :integer
#  raw         :text
#  synced_at   :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  ext_id      :string
#
# Indexes
#
#  index_advertisers_on_network_and_ext_id  (network,ext_id) UNIQUE
#
FactoryBot.define do
  factory :advertiser do
    name { Faker::Company.name }
    network { Advertiser.networks.keys.sample }
    ext_id { Faker::Alphanumeric.alphanumeric }
  end
end
