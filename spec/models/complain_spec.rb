# == Schema Information
#
# Table name: complains
#
#  id         :bigint           not null, primary key
#  data       :jsonb
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_complains_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Complain, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
