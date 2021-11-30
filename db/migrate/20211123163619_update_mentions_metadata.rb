class UpdateMentionsMetadata < ActiveRecord::Migration[6.1]
  def change
    # TODO: remove after migration
    Mention.find_each do |mention|
      attacher = ImageUploader::Attacher.from_model(mention, :image)
      attacher.refresh_metadata!
      attacher.atomic_persist
    end
  end
end
