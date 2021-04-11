# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Devise::Mailer.reset_password_instructions' do
  before do
    I18n.locale = :ru
  end

  let!(:token) { user.send_reset_password_instructions }
  let(:user) { create(:user) }
  let(:mail) { Devise::Mailer.deliveries.last }

  it 'renders the subject' do
    expect(mail.subject).to eq('Инструкции по восстановлению пароля')
  end

  it 'renders the receiver email' do
    expect(mail.to).to eq([user.email])
  end

  it 'renders the sender email' do
    expect(mail.from).to eq([from_email])
  end

  it 'includes reset password link' do
    expect(mail.body.encoded)
      .to include(%(<a href="http://example.com/auth/password/edit?reset_password_token=#{token}">Изменить пароль</a>))
  end
end
