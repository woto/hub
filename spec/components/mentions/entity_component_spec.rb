# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mentions::EntityComponent, type: :component do
  it 'renders entities popover button' do
    expect(
      render_inline(described_class.new(entity: %w[title 555])).to_html
    ).to eq <<~HERE.strip
      <div data-controller="popover" class="d-inline-block" data-popover-url-value="/en/entities/555/popover">
        <a tabindex="0" class="btn btn-sm btn-info mb-1 me-1" data-popover-target="hoverableElement" href="/en/entities/555">
          title
      </a>
      </div>
    HERE
  end
end
