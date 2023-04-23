# frozen_string_literal: true

require 'rails_helper'

describe 'hub:elastic' do
  after { subject.execute }

  describe 'hub:elastic:clean' do
    it { expect(Elastic::DeleteIndexInteractor).to receive(:call).with(index: Elastic::IndexName.pick('*')) }
  end
end
