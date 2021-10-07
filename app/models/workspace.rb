# frozen_string_literal: true

# == Schema Information
#
# Table name: workspaces
#
#  id         :bigint           not null, primary key
#  controller :string
#  is_default :boolean          default(FALSE), not null
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
  belongs_to :user, counter_cache: true

  validates :name, presence: true
  validates :controller, inclusion: { in: %w[tables/accounts tables/checks tables/favorites tables/feeds tables/help
                                             tables/news tables/offers tables/post_categories tables/posts
                                             tables/transactions tables/users] }

  before_save do
    self.class.where(user: user, controller: controller, is_default: true).update_all(is_default: false) if is_default
  end
end
