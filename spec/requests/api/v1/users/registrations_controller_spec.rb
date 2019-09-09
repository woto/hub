# frozen_string_literal: true

require 'spec_helper'

describe Api::V1::Users::RegistrationsController, type: :request do
  def make
    post '/api/v1/users', params: {
      user: {
        email: 'oganer@gmail.com',
        password: '123123123'
      }
    }
  end

  it 'creates user' do
    expect { make }.to change(User, :count).by(1)
  end

  it 'sends a confirmation email' do
    expect { make }.to change(ActionMailer::Base.deliveries, :count).by(1)
  end

  it 'contains valid confirmation link' do
    # TODO: rewrite with dynamic host
    make
    content = ActionMailer::Base.deliveries.first.body.encoded
    expect(content).to include("https://nv6.ru/users/confirmation?confirmation_token=#{User.last.confirmation_token}")
  end
end
