# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mentions::EntityComponent, type: :component do
  it 'renders entities popover button' do
    expect(
      render_inline(described_class.new(entity: %w[title 555])).to_html
    ).to eq <<~HERE.strip
      <div data-controller="mentions-entity-popover" class="d-inline-block" data-mentions-entity-popover-id-value="555">
        <a tabindex="0" class="btn btn-sm btn-info mb-1 me-1" data-mentions-entity-popover-target="entityButton" href="#">
          title
      </a>
      </div>
    HERE
  end
end
