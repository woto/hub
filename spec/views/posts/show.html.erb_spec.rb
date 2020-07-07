# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'posts/show', type: :view do
  before do
    @post = assign(:post, Post.create!(
                            title: 'Title',
                            status_state: 'draft',
                            user: create(:user)
                          ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/draft/)
    expect(rendered).to match(//)
  end
end
