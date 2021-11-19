require 'rails_helper'

describe EntityPolicy do
  subject { described_class }

  permissions :new?, :show?, :index?, :create?, :destroy? do
    it 'allows to any user' do
      expect(subject).to permit(nil, nil)
    end
  end
end
