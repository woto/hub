class FillHostnameInTables < ActiveRecord::Migration[6.1]
  def change
    # TODO: remove later
    Mention.find_each(&:save)
    Entity.find_each(&:save)
  end
end
