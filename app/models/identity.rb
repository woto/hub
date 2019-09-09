# frozen_string_literal: true

# https://github.com/omniauth/omniauth/wiki/Managing-Multiple-Providers
class Identity < ApplicationRecord
  belongs_to :user
end
