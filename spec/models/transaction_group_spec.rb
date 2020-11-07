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
require 'rails_helper'

RSpec.describe TransactionGroup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
