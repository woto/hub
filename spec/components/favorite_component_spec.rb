require 'rails_helper'

describe StarFavoriteComponent, type: :component do
  pending "add some examples to (or delete) #{__FILE__}"

  it "renders something useful" do
    expect(
      render_inline(described_class.new(ext_id: '1', favorites_items_kind: '1', is_favorite: true)) { "Hello, components!" }.css("*").to_html
    ).to include(
      "Hello, components!"
    )
  end
end
