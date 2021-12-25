# frozen_string_literal: true

require 'rails_helper'

shared_examples 'shared_hostname_existed' do
  context 'when hostname already exists' do
    it 'assigns it to the subject without hostname creation' do
      expect do
        expect do
          subject.save
        end.not_to change(Hostname, :count)
      end.to change(described_class, :count)

      expect(subject.hostname).to eq(hostname)
    end
  end
end
