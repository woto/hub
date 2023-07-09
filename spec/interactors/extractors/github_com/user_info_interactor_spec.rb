# frozen_string_literal: true

require 'rails_helper'

describe Extractors::GithubCom::UserInfoInteractor do
  subject { described_class.call(user: 'user') }

  before do
    stub_request(:get, 'https://api.github.com/users/user')
      .to_return(
        status: 200,
        body: {}.to_json,
        headers: { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
      )
  end

  it { is_expected.to have_attributes(object: {}) }
end
