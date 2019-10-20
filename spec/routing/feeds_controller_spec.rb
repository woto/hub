# frozen_string_literal: true

require 'rails_helper'

describe 'Feeds', type: :routing do
  it 'Routes feeds' do
    expect(get('/feeds')).to route_to('home#index')
  end
end
