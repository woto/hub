# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mentions::KindTextComponent, type: :component do
  it 'renders kind text component' do
    expect(
      render_inline(described_class.new(kind_text: 'image')).to_html
    ).to eq <<~HERE.strip
      <small class="text-nowrap text-secondary d-inline-block rounded-1 bg-white border border-muted p-1 me-1 mb-1">
        <span data-bs-toggle="tooltip" data-bs-container="body" data-bs-placement="top" title="Фотография или скриншот. Это так же может быть текст на картинке.">
        <i class="fa-fw fa-lg fas fa-image"></i>
      </span>
      </small>
    HERE
  end
end
