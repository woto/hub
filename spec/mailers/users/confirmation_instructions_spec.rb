require 'rails_helper'

RSpec.describe 'Devise::Mailer.confirmation_instructions' do
  let(:user) { create(:user) }
  let(:mail) { Devise::Mailer.deliveries.last }

  before do
    I18n.locale = :ru
    user.send_confirmation_instructions
  end

  it 'renders the subject' do
    expect(mail.subject).to eq('Инструкции по подтверждению учетной записи')
  end

  it 'renders the receiver email' do
    expect(mail.to).to eq([user.email])
  end

  it 'renders the sender email' do
    expect(mail.from).to eq([from_email])
  end

  it 'includes unlock link' do
    expect(mail.body.encoded)
    .to include("<a href=\"http://example.com/auth/verification?confirmation_token=#{user.confirmation_token}\">Активировать</a>")
  end
end
