
require 'rails_helper'

shared_examples "includes_robots_noindex" do |parameter|
  it 'includes X-Robots-Tag: noindex' do
    get send(path.first, path.second[:params].merge(params))
    expect(headers.to_h).to include('X-Robots-Tag' => 'noindex')
  end
end

shared_examples "not_to_includes_noindex" do |parameter|
  it 'does not include X-Robots-Tag: noindex' do
    get send(path.first, path.second[:params].merge(params))
    expect(headers.to_h).not_to include('X-Robots-Tag' => 'noindex')
  end
end
