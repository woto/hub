# frozen_string_literal: true

require 'rails_helper'

shared_examples 'shared_favorites_unauthenticated' do
  it 'clicking on "star" requires to authenticate' do
    expect(page).to have_text('Вам необходимо войти в систему или зарегистрироваться.')
  end
end
