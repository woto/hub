class CreateTemplate3s < ActiveRecord::Migration[6.0]
  def change
    create_table :template3s do |t|
      t.string :title

      t.timestamps
    end
  end
end
