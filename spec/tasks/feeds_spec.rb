# frozen_string_literal: true

require 'rails_helper'

describe "hub:feeds" do
  after { subject.execute }

  describe 'hub:feeds:sweep' do
    it { expect(Feeds::Sweep).to receive(:call) }
  end

  describe 'hub:feeds:language' do
    it { expect(Feeds::StoreLanguage).to receive(:call) }
  end
end
