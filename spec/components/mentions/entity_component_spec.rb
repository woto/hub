# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mentions::EntityComponent, type: :component do
  around do |example|
    I18n.with_locale(:ru) { example.run }
  end

  context 'when is_main is false' do
    it 'renders secondary color' do
      expect(
        render_inline(described_class.new(entity: [{ 'is_main' => false, 'title' => 'title' }, 555])).to_html
      ).to eq <<~HERE.strip
        <div data-controller="popover" class="d-inline-block" data-popover-url-value="/ru/entities/555/popover">
          <a tabindex="0" class="btn btn-sm mb-1 me-1 btn-secondary" data-popover-target="hoverableElement" href="/ru/entities/555">
            title
        </a>
        </div>
      HERE
    end

    context 'when is_main is true' do
      it 'renders primary color' do
        expect(
          render_inline(described_class.new(entity: [{ 'is_main' => true, 'title' => 'title' }, 555])).to_html
        ).to eq <<~HERE.strip
          <div data-controller="popover" class="d-inline-block" data-popover-url-value="/ru/entities/555/popover">
            <a tabindex="0" class="btn btn-sm mb-1 me-1 btn-blue" data-popover-target="hoverableElement" href="/ru/entities/555">
              title
          </a>
          </div>
        HERE
      end
    end
  end
end
