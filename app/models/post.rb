# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  status_state :string           not null
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
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
