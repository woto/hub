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
end
