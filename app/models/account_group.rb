# frozen_string_literal: true

# == Schema Information
#
# Table name: account_groups
#
#  id         :bigint           not null, primary key
#  identifier :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AccountGroup < ApplicationRecord
  has_many :accounts, as: :subject
  validates :identifier, uniqueness: true

  class << self
    def hub
      find_or_create_by!(identifier: 'hub')
    end

    def yandex
      find_or_create_by!(identifier: 'yandex')
    end

    def stakeholder
      find_or_create_by!(identifier: 'woto')
    end

    def advego
      find_or_create_by!(identifier: 'advego')
    end
  end

  def to_label
    identifier
  end
end
