# == Schema Information
#
# Table name: realms
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  locale     :string           not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Realm, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
