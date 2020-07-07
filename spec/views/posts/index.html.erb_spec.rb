# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'posts/index', type: :view do
  before do
    assign(:posts, [
             Post.create!(
               title: 'Title',
               status_state: 'draft',
               user: create(:user)
             ),
             Post.create!(
               title: 'Title',
               status_state: 'draft',
               user: create(:user)
             )
           ])
  end

  it 'renders a list of posts' do
    render
    assert_select 'tr>td', text: 'Title'.to_s, count: 2
    assert_select 'tr>td', text: 'draft'.to_s, count: 2
  end
end
