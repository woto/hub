class AddLanguageToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :language, :string
  end
end
