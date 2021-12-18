# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TextTagComponent, type: :component do
  context 'when alias looks like url' do
    it 'renders badge with link' do
      expect(
        render_inline(described_class.new(text_tag: 'https://example.com')).to_html
      ).to eq <<~HERE.strip
        <span style="max-width: 200px" class="badge bg-cyan text-truncate user-select-all me-1 mb-1 text-break d-inline-block">
          <a class="text-white" rel="noreferrer nofollow ugc" href="https://example.com">example.com</a>
        </span>
      HERE
    end

    context 'when passes linkify: false' do
      it 'does not linkifies urls' do
        expect(
          render_inline(described_class.new(text_tag: 'https://example.com', linkify: false)).to_html
        ).to eq <<~HERE.strip
          <span style="max-width: 200px" class="badge bg-cyan text-truncate user-select-all me-1 mb-1 text-break d-inline-block">
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
      ).to eq <<~HERE.strip
        <span style="max-width: 200px" class="badge bg-cyan text-truncate user-select-all me-1 mb-1 text-break d-inline-block">
          example
        </span>
      HERE
    end
  end

  context 'when passed "color" parameter' do
    it 'renders badge without link' do
      expect(
        render_inline(described_class.new(text_tag: 'example', color: 'red')).to_html
      ).to eq <<~HERE.strip
        <span style="max-width: 200px" class="badge bg-red text-truncate user-select-all me-1 mb-1 text-break d-inline-block">
          example
        </span>
      HERE
    end
  end
end
