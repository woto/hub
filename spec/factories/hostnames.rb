# == Schema Information
#
# Table name: hostnames
#
#  id             :bigint           not null, primary key
#  entities_count :integer          default(0), not null
#  mentions_count :integer          default(0), not null
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :hostname do
    title { Faker::Internet.domain_name }
  end
end
