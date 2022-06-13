# frozen_string_literal: true

require 'rails_helper'

describe Extractors::GithubCom::Index do
  subject { described_class.call(label: label) }

  let(:repository) { OpenStruct.new(object: { default_branch: nil }) }
  let(:readme) { OpenStruct.new({}) }

  before do
    expect(Extractors::GithubCom::Repository).to(
      receive(:call).with(repo: 'rails/rails').and_return(repository)
    )
    expect(Extractors::GithubCom::Readme).to(
      receive(:call).with(repo: 'rails/rails').and_return(readme)
    )
  end

  context 'when label is /rails/rails' do
    let(:label) { '/rails/rails' }

    specify { expect { subject }.not_to raise_error }
  end

  context 'when label is https://github.com/rails/rails' do
    let(:label) { 'https://github.com/rails/rails' }

    specify { expect { subject }.not_to raise_error }
  end

  context 'when label is https://www.github.com/rails/rails' do
    let(:label) { 'https://www.github.com/rails/rails' }

    specify { expect { subject }.not_to raise_error }
  end

  context 'when label is /rails/rails/' do
    let(:label) { '/rails/rails/' }

    specify { expect { subject }.not_to raise_error }
  end
end
