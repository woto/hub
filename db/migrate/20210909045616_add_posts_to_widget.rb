class AddPostsToWidget < ActiveRecord::Migration[6.1]
  def change
    add_column :widgets, :posts, :integer, array: true, default: []
  end
end
