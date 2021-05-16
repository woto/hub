shared_examples 'logidzable' do
  before do
    factory_name = described_class.name.underscore
    Current.set(responsible: create(:user, role: :admin)) { create(factory_name) }
  end

  context 'with #with_log_data' do
    it 'does not raise error' do
      expect { described_class.with_log_data.first.log_size }.not_to raise_error
    end
  end

  context 'without #with_log_data' do
    it 'raises error' do
      expect { described_class.first.log_version }.to raise_error(Module::DelegationError)
    end
  end
end
