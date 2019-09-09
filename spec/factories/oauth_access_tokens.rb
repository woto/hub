# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_access_tokens, class: 'Doorkeeper::AccessToken' do
    resource_owner_id { create(:user).id }
    token { Faker::Omniauth.google[:credentials][:token] }
  end
end
