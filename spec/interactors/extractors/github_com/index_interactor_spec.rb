# frozen_string_literal: true

require 'rails_helper'

describe Extractors::GithubCom::IndexInteractor do
  subject { described_class.call(q: q) }

  context 'when q is a search string' do
    let(:repos) { OpenStruct.new({}) }

    before do
      expect(Extractors::GithubCom::SearchInteractor).to(
        receive(:call).with(q: q).and_return(repos)
      )
    end

    context 'when `q` is a `rails`' do
      let(:q) { 'rails' }

      specify { expect { subject }.not_to raise_error }
    end

    context 'when `q` is a `ruby on rails`' do
      let(:q) { 'ruby on rails' }

      specify { expect { subject }.not_to raise_error }
    end
  end

  context 'when q is a repo name' do
    let(:repository) { OpenStruct.new(object: { default_branch: nil }) }
    let(:readme) { OpenStruct.new({}) }

    before do
      expect(Extractors::GithubCom::RepositoryInteractor).to(
        receive(:call).with(repo: 'rails/rails').and_return(repository)
      )
      expect(Extractors::GithubCom::ReadmeInteractor).to(
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
