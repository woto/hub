# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :email, :confirmed_at, :unconfirmed_email, :role
end
