# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :email, :role
  has_many :identities

  def email
    {
      main_address: object.email,
      unconfirmed_address: object.unconfirmed_email,
      is_confirmed: !object.confirmed_at.nil?
    }
  end

  class IdentitySerializer < ActiveModel::Serializer
    attributes :provider
  end
end
