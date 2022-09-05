# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReactComponent, type: :component do
  it 'renders correctly' do
    expect(
      render_inline(described_class.new(name: 'name', props: { variable: 'value' }, class: 'class')) do |component|
        component.draft { 'draft value' }
      end.to_html
    ).to eq <<~HERE.strip
      <div class="class" data-react="name" data-props='{"variable":"value"}'>
        draft value
      </div>
    HERE
  end
end
