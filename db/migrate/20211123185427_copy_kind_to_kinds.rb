class CopyKindToKinds < ActiveRecord::Migration[6.1]
  def change
    # reversible do |dir|
    #   dir.up do
    #     Mention.find_each do |mention|
    #       mention.kinds = [Mention::KINDS[mention.kind]]
    #       mention.save!
    #     end
    #   end
    # end
  end
end
