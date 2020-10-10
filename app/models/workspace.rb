# frozen_string_literal: true

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
class Workspace < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :controller, inclusion: %w[posts feeds users]
end
