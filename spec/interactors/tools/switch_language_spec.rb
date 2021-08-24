# frozen_string_literal: true

require 'rails_helper'

describe Tools::SwitchLanguage do
  subject do
    described_class.call(
      subdomains: request.subdomains,
      host: request.host,
      locale: 'ru'
    ).object
  end

  let(:request) { ActionDispatch::TestRequest.create({ 'HTTP_HOST' => host, 'PATH_INFO' => path }) }

  context 'when url is http://localhost:3000' do
    let(:host) { 'localhost:3000' }
    let(:path) { '/' }

    it { is_expected.to match({ locale: 'ru' }) }
  end

  context 'when url is http://localhost:3000/ru' do
    let(:host) { 'localhost:3000' }
    let(:path) { '/ru' }

    it { is_expected.to match({ locale: 'ru' }) }
  end

  context 'when url is http://ru.localhost:3000' do
    let(:host) { 'ru.localhost:3000' }
    let(:path) { '/' }

    it { is_expected.to match({locale: 'ru'}) }
  end

  context 'when url is http://ru.192.168.31.80.nip.io:3000' do
    let(:host) { 'ru.192.168.31.80.nip.io:3000' }
    let(:path) { '/' }

    it { is_expected.to match({ host: 'ru.192.168.31.80.nip.io' }) }
  end

  context 'when url is http://192.168.31.80.nip.io:3000' do
    let(:host) { '192.168.31.80.nip.io:3000' }
    let(:path) { '/' }

    it { is_expected.to match({ locale: 'ru' }) }
  end

  context 'when url is http://foo.192.168.31.80.nip.io:3000' do
    let(:host) { 'foo.192.168.31.80.nip.io:3000' }
    let(:path) { '/' }

    it { is_expected.to match({ locale: 'ru' }) }
  end

  context 'when url is http://ru.192.168.31.80.nip.io:3000/ru' do
    let(:host) { 'ru.192.168.31.80.nip.io:3000' }
    let(:path) { '/ru' }

    it { is_expected.to match({host: 'ru.192.168.31.80.nip.io'}) }
  end
end
