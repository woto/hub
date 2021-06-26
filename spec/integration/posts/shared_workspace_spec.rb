# frozen_string_literal: true

require 'rails_helper'

describe 'Posts shared workspace', type: :system do
  it_behaves_like 'shared workspace authenticated' do
    let(:cols) { '0.6.5.16.13' }
    let(:plural) { 'posts' }
    let(:user) { create(:user, role: 'admin') }
  end
end
