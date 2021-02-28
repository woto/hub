# frozen_string_literal: true

# == Schema Information
#
# Table name: realms
#
#  id         :bigint           not null, primary key
#  kind       :integer          not null
#  locale     :string           not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

describe Realm, type: :model do
  # it_behaves_like 'elasticable'
  pending "add some examples to (or delete) #{__FILE__}"
end
