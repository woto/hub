class RemoveAliasesColumnFromEntities < ActiveRecord::Migration[6.1]
  def change
    remove_column :entities, :aliases, :jsonb
  end
end
