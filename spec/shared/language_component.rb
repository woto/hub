require 'rails_helper'

shared_examples 'shared_language_component', focus: true do
  it 'has correct href' do
    click_on("language-component")
    selector = "[href='#{link}']"
    expect(page).to have_css(selector, visible: :all)
  end
end
