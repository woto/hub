require 'rails_helper'

RSpec.describe 'Devise::Mailer.unlock_instructions' do
  let(:user) { create(:user) }
  let(:mail) { Devise::Mailer.deliveries.last }

  before do
    I18n.locale = :ru
    user.lock_access!
  end

  it 'renders the subject' do
    expect(mail.subject).to eq('Инструкции по разблокировке учетной записи')
  end

  it 'renders the receiver email' do
    expect(mail.to).to eq([user.email])
  end

  it 'renders the sender email' do
    expect(mail.from).to eq([from_email])
  end

  it 'includes unlock link' do
    expect(mail.body.encoded)
      .to match(/<a href="http:\/\/example\.com\/auth\/unblock\?unlock_token=.*">Разблокировать учетную запись<\/a>/)
  end
end
