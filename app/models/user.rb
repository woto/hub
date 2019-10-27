# frozen_string_literal: true

class User < ApplicationRecord
  include Authenticatable
  include Authorizationable
end
