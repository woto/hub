# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SitemapJob, type: :job do
  subject { described_class.perform_now('zzz') }

  it 'works' do
    expect(SitemapGenerator::Interpreter).to receive(:run).with({ config_file: File.join(Rails.root, 'config/zzz') })
    subject
  end
end
