# frozen_string_literal: true

require 'rails_helper'

describe "hub:elastic" do
  after { subject.execute }

  describe "hub:elastic:delete_all" do
    it { expect(Elastic::DeleteAll).to receive(:call) }
  end

  describe "hub:elastic:delete_offers" do
    it { expect(Elastic::DeleteOffers).to receive(:call) }
  end
end
