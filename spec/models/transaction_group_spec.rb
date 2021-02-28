# frozen_string_literal: true

# == Schema Information
#
# Table name: transaction_groups
#
#  id         :bigint           not null, primary key
#  kind       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

describe TransactionGroup, type: :model do
  # it_behaves_like 'elasticable'
  pending "add some examples to (or delete) #{__FILE__}"
end
