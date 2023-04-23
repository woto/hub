require 'rails_helper'

describe Sync::AdmitadJob, type: :job do
  subject { described_class.perform_now }

  context 'when unable to find token in cache' do
    let(:context) { instance_double(Interactor::Context, failure?: true) }

    it 'retrieves new token' do
      expect(Sync::Admitad::Token::RestoreInteractor).to receive(:call).and_return(context)
      expect(Sync::Admitad::Token::RetrieveInteractor).to receive(:call)
      expect(Sync::Admitad::SyncInteractor).to receive(:call)
      subject
    end
  end

  context 'when token found in cache' do
    let(:context) { instance_double(Interactor::Context, failure?: false) }

    it 'does not tries to retrieve it' do
      expect(Sync::Admitad::Token::RestoreInteractor).to receive(:call).and_return(context)
      expect(Sync::Admitad::Token::RetrieveInteractor).not_to receive(:call)
      expect(Sync::Admitad::SyncInteractor).to receive(:call)
      subject
    end
  end
end
