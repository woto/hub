# frozen_string_literal: true

require 'rails_helper'

describe "hub:elastic" do
  after { subject.execute }

  describe "hub:elastic:clean" do
    it { expect(Elastic::DeleteIndex).to receive(:call).with(index_name: Elastic::IndexName.wildcard) }
  end
end
