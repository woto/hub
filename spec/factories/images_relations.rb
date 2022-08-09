# == Schema Information
#
# Table name: images_relations
#
#  id            :bigint           not null, primary key
#  dark          :boolean
#  order         :integer
#  relation_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  image_id      :bigint           not null
#  relation_id   :bigint           not null
#  user_id       :bigint
#
# Indexes
#
#  index_images_relations_on_image_id  (image_id)
#  index_images_relations_on_relation  (relation_type,relation_id)
#  index_images_relations_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (image_id => images.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :images_relation do
    image
    relation { nil }
    # user
  end
end
