# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entities::AliasComponent, type: :component do
  context 'when alias looks like url' do
    it 'renders badge with link' do
      expect(
        render_inline(described_class.new(alias: 'https://example.com')).to_html
      ).to eq <<~HERE
        <span class="badge bg-cyan user-select-all">
          <a class="text-white" rel="noreferrer" href="https://example.com">https://example.com</a>
        </span>
      HERE
    end
  end

  context 'when alias does not look like url' do
    it 'renders badge without link' do
      expect(
        render_inline(described_class.new(alias: 'example')).to_html
      ).to eq <<~HERE
        <span class="badge bg-cyan user-select-all">
          example
        </span>
      HERE
    end
  end
end
