require 'rails_helper'

RSpec.describe SitemapJob, type: :job do
  subject { described_class.perform_now }

  it 'works' do
    expect(SitemapGenerator::Interpreter).to receive(:run)
    subject
  end
end
