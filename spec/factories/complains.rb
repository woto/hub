# frozen_string_literal: true

# == Schema Information
#
# Table name: complains
#
#  id         :bigint           not null, primary key
#  data       :jsonb
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_complains_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :complain do
    text { 'text' }
  end
end
