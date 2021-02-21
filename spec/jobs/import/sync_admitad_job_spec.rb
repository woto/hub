require 'rails_helper'

RSpec.describe Import::SyncAdmitadJob, type: :job do
  subject { described_class.perform_now }

  context 'when unable to find token in cache' do
    let(:context) { instance_double(Interactor::Context, failure?: true) }

    it 'retrieves new token' do
      expect(Networks::Admitad::Token::Restore).to receive(:call).and_return(context)
      expect(Networks::Admitad::Token::Retrieve).to receive(:call)
      expect(Networks::Admitad::Sync).to receive(:call)
      subject
    end
  end

  context 'when token found in cache' do
    let(:context) { instance_double(Interactor::Context, failure?: false) }

    it 'does not tries to retrieve it' do
      expect(Networks::Admitad::Token::Restore).to receive(:call).and_return(context)
      expect(Networks::Admitad::Token::Retrieve).not_to receive(:call)
      expect(Networks::Admitad::Sync).to receive(:call)
      subject
    end
  end
end
