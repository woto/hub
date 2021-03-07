require 'rails_helper'

describe Sync::AdmitadJob, type: :job do
  subject { described_class.perform_now }

  context 'when unable to find token in cache' do
    let(:context) { instance_double(Interactor::Context, failure?: true) }

    it 'retrieves new token' do
      expect(Sync::Admitad::Token::Restore).to receive(:call).and_return(context)
      expect(Sync::Admitad::Token::Retrieve).to receive(:call)
      expect(Sync::Admitad::Sync).to receive(:call)
      subject
    end
  end

  context 'when token found in cache' do
    let(:context) { instance_double(Interactor::Context, failure?: false) }

    it 'does not tries to retrieve it' do
      expect(Sync::Admitad::Token::Restore).to receive(:call).and_return(context)
      expect(Sync::Admitad::Token::Retrieve).not_to receive(:call)
      expect(Sync::Admitad::Sync).to receive(:call)
      subject
    end
  end
end
