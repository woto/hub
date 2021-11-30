# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mentions::KindIconComponent, type: :component do
  it 'renders something useful' do
    expect(
      render_inline(described_class.new(kind: 'image', hint: false)).to_html
    ).to eq <<~HERE.strip
      <span data-bs-toggle="tooltip" data-bs-offset="10,20" data-bs-container="body" data-bs-placement="left" title='&lt;span class="translation_missing" title="translation missing: en.mentions.kind_icon_component.hints.image"&gt;Image&lt;/span&gt;'>
        <i class="fas fa-fw fa-image"></i>
        <span class="translation_missing" title="translation missing: en.mentions.kind_icon_component.titles.image">Image</span>
      </span>
    HERE
  end
end
