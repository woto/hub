# == Schema Information
#
# Table name: workspaces
#
#  id         :bigint           not null, primary key
#  controller :string
#  name       :string
#  path       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_workspaces_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :workspace do
    user
    controller { "feeds" }
    name { Faker::App.name }
    path { Faker::Internet.slug }
  end
end
