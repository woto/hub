# frozen_string_literal: true

class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :role
  # has_one :profile, serializer: UserProfileSerializer
  # has_many :identities, serializer: UserIdentitiesSerializer

  attribute :email do |object|
    {
      main_address: object.email,
      unconfirmed_address: object.unconfirmed_email,
      is_confirmed: object.confirmed_at.present?
    }
  end
end
