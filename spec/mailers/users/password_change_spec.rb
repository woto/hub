# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Devise::Mailer.password_change' do
  before do
    I18n.locale = :ru
    user.send(:send_devise_notification, :password_change)
  end

  let(:user) { create(:user) }
  let(:mail) { Devise::Mailer.deliveries.last }

  it 'renders the subject' do
    expect(mail.subject).to eq('Пароль изменен')
  end

  it 'renders the receiver email' do
    expect(mail.to).to eq([user.email])
  end

  it 'renders the sender email' do
    expect(mail.from).to eq([from_email])
  end

  it 'includes text about changed email' do
    expect(mail.body.encoded)
      .to include('ваш пароль был изменен')
  end
end
