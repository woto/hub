# frozen_string_literal: true

class User < ApplicationRecord
  include Authenticatable
  include Authorizationable
  has_one :profile, dependent: :destroy
  has_many :posts
end
