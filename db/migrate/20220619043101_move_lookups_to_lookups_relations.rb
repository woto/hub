class MoveLookupsToLookupsRelations < ActiveRecord::Migration[6.1]
  def change
    Lookup.find_each do |lookup|
      LookupsRelation.create!(lookup: lookup, relation_id: lookup.entity_id, relation_type: 'Entity')
    end
  end
end
