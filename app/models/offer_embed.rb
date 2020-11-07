# == Schema Information
#
# Table name: offer_embeds
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  picture     :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_offer_embeds_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class OfferEmbed < ApplicationRecord
  belongs_to :user

  include GlobalID::Identification
  include ActionText::Attachable

  def to_trix_content_attachment_partial_path
    'offer_embeds/offer_embed_preview'
  end
end
