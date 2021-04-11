# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Devise::Mailer.email_changed' do
  before do
    I18n.locale = :ru
  end

  let(:email) { Faker::Internet.email }
  let!(:token) { user.send(:send_devise_notification, :email_changed, to: email) }
  let(:user) { create(:user) }
  let(:mail) { Devise::Mailer.deliveries.last }

  it 'renders the subject' do
    expect(mail.subject).to eq('Email изменен')
  end

  it 'renders the receiver email' do
    expect(mail.to).to eq([email])
  end

  it 'renders the sender email' do
    expect(mail.from).to eq([from_email])
  end

  it 'includes text about changed email' do
    expect(mail.body.encoded)
      .to include("ваш email был изменен на #{user.email}")
  end
end
