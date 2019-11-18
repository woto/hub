# frozen_string_literal: true

class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :role
  # has_one :profile, serializer: UserProfileSerializer
  # has_many :identities, serializer: UserIdentitiesSerializer

  # TODO: consider remove it from here
  attribute :identities do |object|
    object.identities.map do |identity|
      {
        provider: identity.provider,
        uid: identity.uid
      }
    end
  end

  attribute :email do |object|
    {
      main_address: object.email,
      unconfirmed_address: object.unconfirmed_email,
      is_confirmed: object.confirmed_at.present?
    }
  end
end
