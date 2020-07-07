# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'posts/new', type: :view do
  before do
    assign(:post, Post.new(
                    title: 'MyString',
                    status_state: 'draft',
                    user: create(:user)
                  ))
  end

  it 'renders new post form' do
    render

    assert_select 'form[action=?][method=?]', posts_path, 'post' do
      assert_select 'input[name=?]', 'post[title]'

      assert_select 'input[name=?]', 'post[status_state]'

      assert_select 'input[name=?]', 'post[user_id]'
    end
  end
end
