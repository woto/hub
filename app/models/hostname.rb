# == Schema Information
#
# Table name: hostnames
#
#  id             :bigint           not null, primary key
#  entities_count :integer          default(0), not null
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Hostname < ApplicationRecord
  has_many :mentions, dependent: :restrict_with_error
  has_many :entities, dependent: :restrict_with_error

  def to_label
    title
  end
end
