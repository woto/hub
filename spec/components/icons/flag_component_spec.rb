require "rails_helper"

RSpec.describe Icons::FlagComponent, type: :component do
  it 'renders icon with flag' do
    expect(
      render_inline(described_class.new(language: 'russian')) {}.to_html
    ).to include(
      '<span class="flag flag-country-ru" data-language="russian"></span>'
    )
  end
end
