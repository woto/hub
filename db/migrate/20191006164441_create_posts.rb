class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :title
      t.text :body
      t.text :url
      t.text :status_state
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
