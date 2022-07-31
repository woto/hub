# == Schema Information
#
# Table name: images_relations
#
#  id            :bigint           not null, primary key
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
require 'rails_helper'

RSpec.describe ImagesRelation, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to belong_to(:image) }
    it { is_expected.to belong_to(:relation) }
  end

  describe 'validations' do
    let(:entity) { create(:entity) }
    let(:image) { create(:image) }

    def create_images_relation
      ImagesRelation.create(image: image, relation: entity)
    end

    it 'does not allow to link same `image` and `relation` twice' do
      expect do
        2.times { create_images_relation }
      end.to change(ImagesRelation, :count).from(0).to(1)
    end
  end
end
