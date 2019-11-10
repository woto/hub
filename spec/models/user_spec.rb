# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'with confirmed email' do
    let(:user) { create(:user) }

    it { expect(user).to be_confirmed }

    it 'receives confirmation email when changes his email' do
      # TODO: rewrite with dynamic host
      expect do
        user.update(email: user.email.prepend('changed_'))
      end.to change(ActionMailer::Base.deliveries, :count).by(2)
    end

    it 'contains correct link in reset password instuctions' do
      reset_password_token = user.send_reset_password_instructions

      content = ActionMailer::Base.deliveries.first.body.encoded
      expect(content).to include("https://en.nv6.ru/reset?reset_password_token=#{reset_password_token}")
    end
  end
end
