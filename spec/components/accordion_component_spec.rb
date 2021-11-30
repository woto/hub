# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccordionComponent, type: :component do
  it 'renders something useful' do
    expect(
      render_inline(
        described_class.new(
          accordion_id: 'accordion_id',
          css_class: 'accordion_css'
        )
      ) do |accordion_component|
        accordion_component.item(item_id: 'item_id', css_class: 'item_css') do |item_component|
          item_component.header do
            'header'
          end
          item_component.body(css_class: 'body_css') do
            'body'
          end
        end
      end.to_html
    ).to eq <<~HERE.strip
      <div class="accordion accordion_css" id="accordion_id">
          <div class="accordion-item item_css">
        <h2 class="accordion-header" id="heading-item_id">
          <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#item_id" aria-expanded="false">
            header
          </button>
        </h2>
        <div id="item_id" class="accordion-collapse collapse" data-bs-parent="#accordion_id">
          <div class="accordion-body body_css">
        body
      </div>
        </div>
      </div>
      </div>
    HERE
  end
end
