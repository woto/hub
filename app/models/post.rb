class Post < ApplicationRecord
  include AASM

  belongs_to :user
  has_many_attached :images

  aasm(:status, column: :status_state) do
    state :draft, initial: true
  end
end
