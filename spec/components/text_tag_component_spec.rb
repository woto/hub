# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TextTagComponent, type: :component do
  context 'when alias looks like url' do
    it 'renders badge with link' do
      expect(
        render_inline(described_class.new(text_tag: 'https://example.com')).to_html
      ).to eq <<~HERE
        <span class="badge bg-cyan user-select-all me-1 mb-1 text-break d-inline-block">
          <a class="text-white" rel="noreferrer" href="https://example.com">https://example.com</a>
        </span>
      HERE
    end

    context 'when passes linkify: false' do
      it 'does not linkifies urls' do
        expect(
          render_inline(described_class.new(text_tag: 'https://example.com', linkify: false)).to_html
        ).to eq <<~HERE
          <span class="badge bg-cyan user-select-all me-1 mb-1 text-break d-inline-block">
            https://example.com
          </span>
        HERE
      end
    end
  end

  context 'when alias does not look like url' do
    it 'renders badge without link' do
      expect(
        render_inline(described_class.new(text_tag: 'example')).to_html
      ).to eq <<~HERE
        <span class="badge bg-cyan user-select-all me-1 mb-1 text-break d-inline-block">
          example
        </span>
      HERE
    end
  end
end
