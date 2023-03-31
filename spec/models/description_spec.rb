# == Schema Information
#
# Table name: descriptions
#
#  id            :bigint           not null, primary key
#  description   :text
#  title         :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  advertiser_id :integer          not null
#  feed_id       :integer          not null
#  offer_id      :string           not null
#
require 'rails_helper'

RSpec.describe Description, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
