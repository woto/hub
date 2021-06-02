class CreateWidgetsSimples < ActiveRecord::Migration[6.1]
  def change
    create_table :widgets_simples do |t|
      t.string :title
      t.string :url
      t.text :body

      t.timestamps
    end
  end
end
