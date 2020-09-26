# frozen_string_literal: true

require 'rails_helper'

describe "hub:gdeslon:sync" do
  it 'calls interactor task' do
    expect(Networks::Gdeslon::Sync).to receive(:call)
    subject.execute
  end
end
