require 'rails_helper'

RSpec.shared_examples "shared_language_component" do
  it 'has correct href' do
    expect(page).to have_css("[data-test-class='language_component'] [data-test-class='link'][href='#{link}']", visible: :all)
  end
end
