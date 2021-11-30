# frozen_string_literal: true

require 'rails_helper'

describe EntityPolicy::Scope do
  subject do
    described_class.new(user, Entity).resolve.to_sql
  end

  let(:user) { nil }

  it { is_expected.not_to include('WHERE') }
end
