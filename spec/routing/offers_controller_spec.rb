# frozen_string_literal: true

require 'rails_helper'

describe 'Offers', type: :routing do
  it 'Routes offers' do
    expect(get('/offers')).to route_to('offers#index')
  end
end
