require 'rails_helper'

shared_examples 'shared_language_component' do
  it 'has correct href' do
    selector = "[data-test-class='language_component'] [data-test-class='link'][href='#{link}']"
    expect(page).to have_css(selector, visible: :all)
  end
end
