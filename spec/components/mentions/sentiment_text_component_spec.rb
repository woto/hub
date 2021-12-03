require "rails_helper"

RSpec.describe Mentions::SentimentTextComponent, type: :component do
  it 'renders sentiment text component' do
    expect(
      render_inline(described_class.new(sentiment_text: 'positive')).to_html
    ).to eq <<~HERE.strip
      <small class="text-nowrap text-secondary d-inline-block rounded-1 bg-white border border-muted p-1 me-1 mb-1">
        <span data-bs-toggle="tooltip" data-bs-container="body" data-bs-placement="top" title="Положительное">
        <i class="fa-lg far fa-fw fa-thumbs-up"></i>
      </span>
      </small>
    HERE
  end
end
