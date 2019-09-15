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
      end.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
