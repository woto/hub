# == Schema Information
#
# Table name: checks
#
#  id         :bigint           not null, primary key
#  amount     :decimal(, )      not null
#  currency   :integer          not null
#  is_payed   :boolean          not null
#  payed_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_checks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :check do
    user
    amount { rand(10) }
    currency { Rails.configuration.global[:currencies].to_a.sample.last }
    # payed { false }
    # payed_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
  end
end
