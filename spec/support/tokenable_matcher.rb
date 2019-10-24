# frozen_string_literal: true

RSpec::Matchers.define :be_like_tokenable do |_expected|
  match do |actual|
    expect(actual).to match(
      'access_token' => an_instance_of(String),
      'expires_in' => an_instance_of(Integer),
      'created_at' => an_instance_of(Integer),
      'refresh_token' => an_instance_of(String),
      'token_type' => 'Bearer'
    )
  end
end
