# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  title        :string
#  status_state :string
#  user_id      :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Post < ApplicationRecord
  include AASM

  belongs_to :user
  has_many_attached :images
  has_rich_text :body

  validates :title, presence: true

  aasm(:status, column: :status_state) do
    state :draft, initial: true
  end
end
