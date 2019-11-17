# frozen_string_literal: true

class ProfileSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :languages, :messengers, :bio, :location
end
