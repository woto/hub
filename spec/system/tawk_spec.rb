# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tawk' do
  context "when TAWK_ENABLED == 'true'" do
    before do
      stub_const('ENV', ENV.to_hash.merge('TAWK_ENABLED' => 'true'))
    end

    it 'shows tawk widget', browser: :desktop do
      get '/dashboard'
      expect(response.body).to match('Tawk_API')
    end
  end

  context "when TAWK_ENABLED == 'false'" do
    before do
      stub_const('ENV', ENV.to_hash.merge('TAWK_ENABLED' => 'false'))
    end

    it 'does not show tawk widget', browser: :desktop do
      get '/dashboard'
      expect(response.body).not_to match('Tawk_API')
    end
  end
end