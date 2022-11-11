class AddUserToLookups < ActiveRecord::Migration[6.1]
  def change
    add_reference :lookups, :user, foreign_key: true
  end
end
