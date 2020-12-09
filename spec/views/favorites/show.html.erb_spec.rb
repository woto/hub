# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'favorites/show', type: :view do
  before do
    @favorite = assign(:favorite, create(:favorite))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
  end
end
