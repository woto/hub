# == Schema Information
#
# Table name: transaction_groups
#
#  id          :bigint           not null, primary key
#  kind        :integer
#  object_hash :jsonb
#  object_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  object_id   :bigint
#
# Indexes
#
#  index_transaction_groups_on_object_type_and_object_id  (object_type,object_id)
#
FactoryBot.define do
  factory :transaction_group do
    
  end
end
