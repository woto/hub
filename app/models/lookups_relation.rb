# == Schema Information
#
# Table name: lookups_relations
#
#  id            :bigint           not null, primary key
#  relation_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  lookup_id     :bigint           not null
#  relation_id   :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_lookups_relations_on_lookup_id  (lookup_id)
#  index_lookups_relations_on_relation   (relation_type,relation_id)
#  index_lookups_relations_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (lookup_id => lookups.id)
#  fk_rails_...  (user_id => users.id)
#
class LookupsRelation < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :lookup
  belongs_to :relation, polymorphic: true

  validates :lookup, uniqueness: { scope: :relation }
end
