# == Schema Information
#
# Table name: template3s
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :template3 do
    title { "MyString" }
  end
end
