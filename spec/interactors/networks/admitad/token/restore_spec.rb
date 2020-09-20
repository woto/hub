# frozen_string_literal: true

require 'rails_helper'

describe Networks::Admitad::Token::Restore do
  it 'finished with success if it founds token in cache' do
    Rails.cache.write(Networks::Admitad::Token::TOKEN_KEY, '123')
    expect(described_class.call).to be_success
  end

  it 'returns context.token with token if it founds token in cache' do
    Rails.cache.write(Networks::Admitad::Token::TOKEN_KEY, '123')
    expect(described_class.call).to have_attributes(token: '123')
  end

  it 'failure if cache is empty' do
    expect(described_class.call).to be_failure
  end
end
