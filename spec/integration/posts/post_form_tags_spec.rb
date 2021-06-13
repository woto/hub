# frozen_string_literal: true

require 'rails_helper'

describe PostsController, type: :system, responsible: :admin do
  let(:post) { create(:post, user: Current.responsible, tags: ['', 'first', 'second']) }

  before do
    create(:post, realm: post.realm, post_category: post.post_category, tags: ['', 'third'])
  end

  it 'changes `post[tags]` correctly' do
    login_as(Current.responsible, scope: :user)
    visit edit_post_path(post, locale: :ru)

    expect(page).to have_select('post[tags][]', visible: :hidden, selected: %w[first second])

    within '.post_tags' do
      find('input').click
      find('input').native.send_key(:backspace)
      find('input').native.send_key('thi')
      find('div.option', text: 'third').click
    end

    expect(page).to have_select('post[tags][]', visible: :hidden, selected: %w[first third])
  end

  it 'allows to add new tags' do
    login_as(Current.responsible, scope: :user)
    visit edit_post_path(post, locale: :ru)

    expect(page).to have_select('post[tags][]', visible: :hidden, selected: %w[first second])

    within '.post_tags' do
      find('.selectize-input').click
      find('input').native.send_key(:backspace)
      find('input').native.send_key('fourth')
      find('input').native.send_key(:enter)
    end

    expect(page).to have_select('post[tags][]', visible: :hidden, selected: %w[first fourth])
  end
end
