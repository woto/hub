# frozen_string_literal: true

# == Schema Information
#
# Table name: identities
#
#  id         :bigint           not null, primary key
#  uid        :string           not null
#  provider   :string           not null
#  user_id    :bigint           not null
#  auth       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#

# https://github.com/omniauth/omniauth/wiki/Managing-Multiple-Providers
class Identity < ApplicationRecord
  belongs_to :user
end
