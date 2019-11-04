# frozen_string_literal: true

class User < ApplicationRecord
  # If oauthenticable is false then
  # password and email don't confirms
  attr_accessor :oauthenticable
  include Authenticatable
  include Authorizationable
end
