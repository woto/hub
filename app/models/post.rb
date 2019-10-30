class Post < ApplicationRecord
  include AASM

  belongs_to :user
  aasm(:status, column: :status_state) do
    state :draft, initial: true
  end
end
