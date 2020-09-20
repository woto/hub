# frozen_string_literal: true

require 'rails_helper'

describe "hub:feeds" do

  after { subject.execute }

  describe 'hub:feeds:sweep' do
    # describe 'https://github.com/crismali/fantaskspec' do
    #   it { is_expected.to depend_on(:environment) }
    #
    #   it "executes some code" do
    #     expect(subject.execute).to eq(task.execute)
    #   end
    #
    #   context "some sort of context" do
    #     it "still uses 'some_task' as the name of the task" do
    #       expect(task_name).to eq("hub:feeds:sweep")
    #       expect(task_name).to eq(subject.name)
    #     end
    #   end
    # end

    it { expect(Feeds::Sweep).to receive(:call) }
  end

  describe 'hub:feeds:language' do
    it { expect(Feeds::StoreLanguage).to receive(:call) }
  end

  describe 'hub:feeds:process' do
    it { expect(Feeds::Process).to receive(:call) }
  end
end
