# frozen_string_literal: true

class MoveAliasesToLookups < ActiveRecord::Migration[6.1]
  def change
    # TODO: remove after migration
    reversible do |dir|
      dir.up do
        Entity.find_each do |entity|
          entity.aliases.each do |_alias|
            next if _alias == ''

            entity.lookups.build(title: _alias)
          end
          entity.save!
        end
      end
    end
  end
end
