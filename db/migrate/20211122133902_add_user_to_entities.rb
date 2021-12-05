class AddUserToEntities < ActiveRecord::Migration[6.1]
  def change
    # TODO: clean (remove at least model invocation)
    add_reference :entities, :user, foreign_key: true
    user_id = User.find_by(email: 'admin@example.com')&.id
    change_column_null :entities, :user_id, false, user_id
  end
end
