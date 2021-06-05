# frozen_string_literal: true

require 'rails_helper'

describe CheckPolicy::Scope do
  subject do
    described_class.new(user, Check).resolve.to_sql
  end

  context 'without user' do
    let(:user) { nil }

    it 'raises error' do
      expect { subject }.to raise_error(Pundit::NotAuthorizedError, 'responsible is not set')
    end
  end

  context 'with user' do
    let(:user) { create(:user, role: :user) }

    it { is_expected.to include(%(WHERE "checks"."user_id" = #{user.id})) }
  end

  context 'with admin' do
    let(:user) { create(:user, role: :admin) }

    it { is_expected.not_to include(%(WHERE "checks"."user_id" = #{user.id})) }
  end
end
