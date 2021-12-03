require "rails_helper"

RSpec.describe Mentions::SentimentIconComponent, type: :component do
  it 'renders sentiment icon component' do
    expect(
      render_inline(described_class.new(sentiment: 'positive')).to_html
    ).to eq <<~HERE.strip
      <span data-bs-toggle="tooltip" data-bs-container="body" data-bs-placement="top" title="Положительное">
        <i class="fa-lg far fa-fw fa-thumbs-up"></i>
      </span>
    HERE
  end
end
