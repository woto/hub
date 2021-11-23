class AddUserToEntities < ActiveRecord::Migration[6.1]
  def change
    add_reference :entities, :user, foreign_key: true
    change_column_null :entities, :user_id, false, User.find_by(email: 'admin@example.com').id
  end
end
