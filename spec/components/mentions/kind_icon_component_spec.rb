# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mentions::KindIconComponent, type: :component do
  it 'renders kind icon component' do
    expect(
      render_inline(described_class.new(kind: 'image')).to_html
    ).to eq <<~HERE.strip
      <span data-bs-toggle="tooltip" data-bs-container="body" data-bs-placement="top" title="Фотография или скриншот. Это так же может быть текст на картинке.">
        <i class="fa-fw fa-lg fas fa-image"></i>
      </span>
    HERE
  end
end
