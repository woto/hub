# frozen_string_literal: true

class User < ApplicationRecord
  # If oauthenticable is true then
  # password and email don't validates
  attr_accessor :oauthenticable
  include Authenticatable
  include Authorizationable
  has_one :profile, dependent: :destroy
  has_one_attached :avatar
end
