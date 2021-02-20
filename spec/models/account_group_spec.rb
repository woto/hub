# == Schema Information
#
# Table name: account_groups
#
#  id         :bigint           not null, primary key
#  identifier :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

describe AccountGroup, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
