# == Schema Information
#
# Table name: account_groups
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AccountGroup < ApplicationRecord
  has_many :accounts, as: :subject
end
