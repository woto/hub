# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id         :bigint           not null, primary key
#  name       :string
#  bio        :text
#  location   :string
#  messengers :jsonb
#  languages  :jsonb
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Profile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
