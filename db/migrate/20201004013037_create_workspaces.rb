class CreateWorkspaces < ActiveRecord::Migration[6.0]
  def change
    create_table :workspaces do |t|
      t.references :user, null: false, foreign_key: true
      t.string :controller
      t.string :name
      t.string :path

      t.timestamps
    end
  end
end
