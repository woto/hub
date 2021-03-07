# frozen_string_literal: true

require 'rails_helper'

describe "hub:feeds" do
  after { subject.execute }

  describe 'hub:feeds:sweep' do
    it { expect(Import::Sweep).to receive(:call) }
  end
end
