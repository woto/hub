# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mentions::KindTextComponent, type: :component do
  it 'renders something useful' do
    expect(
      render_inline(described_class.new(kind_text: 'image')).to_html
    ).to eq <<~HERE
      <small class="text-nowrap bg-white text-secondary d-inline-block border-1 border p-1">
        <span data-bs-toggle="tooltip" data-bs-offset="10,20" data-bs-container="body" data-bs-placement="left" title='&lt;span class="translation_missing" title="translation missing: en.mentions.kind_icon_component.hints.image"&gt;Image&lt;/span&gt;'>
        <i class="fas fa-fw fa-image"></i>
        <span class="translation_missing" title="translation missing: en.mentions.kind_icon_component.titles.image">Image</span>
      </span>
      </small>
    HERE
  end
end
