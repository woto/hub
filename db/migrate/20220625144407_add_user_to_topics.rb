class AddUserToTopics < ActiveRecord::Migration[6.1]
  def change
    add_reference :topics, :user, foreign_key: true
  end
end
