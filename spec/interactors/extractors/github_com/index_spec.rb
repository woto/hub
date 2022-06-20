# frozen_string_literal: true

require 'rails_helper'

describe Extractors::GithubCom::Index do
  subject { described_class.call(q: q) }

  context 'when q is a search string' do
    let(:repos) { OpenStruct.new({}) }

    before do
      expect(Extractors::GithubCom::Search).to(
        receive(:call).with(q: 'rails').and_return(repos)
      )
    end

    context 'when q is rails' do
      let(:q) { 'rails' }

      specify { expect { subject }.not_to raise_error }
    end
  end

  context 'when q is a repo name' do
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

    context 'when q is /rails/rails' do
      let(:q) { '/rails/rails' }

      specify { expect { subject }.not_to raise_error }
    end

    context 'when q is https://github.com/rails/rails' do
      let(:q) { 'https://github.com/rails/rails' }

      specify { expect { subject }.not_to raise_error }
    end

    context 'when q is https://www.github.com/rails/rails' do
      let(:q) { 'https://www.github.com/rails/rails' }

      specify { expect { subject }.not_to raise_error }
    end

    context 'when q is /rails/rails/' do
      let(:q) { '/rails/rails/' }

      specify { expect { subject }.not_to raise_error }
    end
  end
end
