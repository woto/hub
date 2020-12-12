# == Schema Information
#
# Table name: realms
#
#  id         :bigint           not null, primary key
#  kind       :integer          not null
#  locale     :string           not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :realm do
    title { Faker::App.unique.name }
  end
end
