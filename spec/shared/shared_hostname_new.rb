# frozen_string_literal: true

require 'rails_helper'

shared_examples 'shared_hostname_new' do
  context 'when hostname of passed url not exists yet' do
    it 'creates hostname and assigns it to the subject' do
      expect do
        expect do
          subject.save
        end.to change(Hostname, :count)
      end.to change(described_class, :count)

      expect(subject.hostname).to eq(Hostname.last)
    end
  end
end
