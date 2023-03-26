class AddYoutubeUrlToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :youtube_url, :string
  end
end
