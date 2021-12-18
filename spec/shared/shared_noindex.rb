# frozen_string_literal: true

require 'rails_helper'

shared_examples 'includes_robots_noindex', focus: true do |_parameter|
  it 'includes X-Robots-Tag: noindex' do
    get send(path.first, path.second[:params].merge(params))
    expect(headers.to_h).to include('X-Robots-Tag' => 'noindex')
  end
end

shared_examples 'not_to_includes_noindex', focus: true do |_parameter|
  it 'does not include X-Robots-Tag: noindex' do
    get send(path.first, path.second[:params].merge(params))
    expect(headers.to_h).not_to include('X-Robots-Tag' => 'noindex')
  end
end
