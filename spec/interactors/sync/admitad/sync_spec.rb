# frozen_string_literal: true

require 'rails_helper'

shared_examples 'compare advertiser' do |name:, ext_id:|
  before do
    run_sync
  end

  specify do
    advertiser = Advertiser.find_by!(ext_id: ext_id)

    expect(advertiser).to have_attributes(
      picture: be_attached,
      is_active: true,
      name: name,
      network: 'admitad',
      raw: match(Regexp.new(name)),
      synced_at: Time.zone.parse('2020-09-20 20:32:44'),
      ext_id: ext_id
    )
  end
end

shared_examples 'compare feed' do |name:, ext_id:, url:|
  before do
    run_sync
  end

  specify do
    feed = Feed.find_by!(ext_id: ext_id)

    expect(feed).to have_attributes(
      operation: 'sync',
      ext_id: ext_id,
      name: name,
      url: url,
      error_class: nil,
      error_text: nil,
      locked_by_tid: '',
      languages: {},
      attempt_uuid: nil,
      raw: match(Regexp.new(name)),
      processing_started_at: nil,
      processing_finished_at: nil,
      synced_at: Time.zone.parse('2020-09-20 20:32:44'),
      succeeded_at: nil,
      offers_count: 0,
      categories_count: 0,
      priority: 0,
      xml_file_path: nil,
      downloaded_file_type: nil,
      is_active: true,
      downloaded_file_size: nil,
      created_at: Time.zone.parse('2020-09-20 20:32:44'),
      updated_at: Time.zone.parse('2020-09-20 20:32:44'),
      log_data: nil
    )
  end
end

describe Sync::Admitad::SyncInteractor do
  let(:limit) { 1 }
  let(:token) { Faker::Alphanumeric.alphanumeric }

  before do
    stub_const('ENV', { 'ADMITAD_WEBSITE' => 34_787 })
    stub_const('Sync::Admitad::SyncInteractor::LIMIT', limit)
  end

  it { expect(ENV['ADMITAD_WEBSITE']).to eq(34_787) }
  it { expect(Sync::Admitad::SyncInteractor::LIMIT).to eq(limit) }

  context 'whith stubbed responses' do
    def run_sync
      travel_to Time.zone.parse('2020-09-20T20:32:44') do
        described_class.call(token: token)
      end
    end

    before do
      3.times do |i|
        stub_request(:get, "https://api.admitad.com/advcampaigns/website/34787/?has_tool=products&limit=#{limit}&offset=#{i}&website=34787")
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(
            status: 200,
            body: file_fixture("syncs/responses/admitad_advertisers_#{i}.json"),
            headers: { content_type: 'application/json' }
          )
      end

      stub_request(:get, 'http://cdn.admitad.com/campaign/images/2017/10/3/fffe92da99b37d46b356b84ea1a6b270.jpg')
        .to_return(status: 200, body: 'some image data', headers: {})
      stub_request(:get, 'http://cdn.admitad.com/campaign/images/2010/10/15/778ecb9bfc0b3b85e223f68facb070c4.jpg')
        .to_return(status: 200, body: 'some image data', headers: {})
    end

    context 'when one of the advertisers is exists' do
      before do
        create(:advertiser, ext_id: '153', network: 'admitad')
      end

      it 'creates one advertiser and updates the second one' do
        run_sync
        expect(Advertiser.count).to eq(2)
      end
    end

    describe 'it creates feed from the first page' do
      it_behaves_like 'compare feed', name: 'Евро_остатки', ext_id: '19088', url: 'http://export.admitad.com/ru/webmaster/websites/34787/products/export_adv_products/?user=username&code=6ad3cb74b8&feed_id=19088&format=xml'
    end

    describe 'it crates feed from the second page' do
      it_behaves_like 'compare feed', name: 'Vseinstrumenti.ru', ext_id: '324', url: 'http://export.admitad.com/ru/webmaster/websites/34787/products/export_adv_products/?user=username&code=6ad3cb74b8&feed_id=324&format=xml'
    end

    describe 'it creates advertiser from the first page' do
      it_behaves_like 'compare advertiser', name: 'Kupivip RU', ext_id: '153'
    end

    describe 'it creates advertiser from the second page' do
      it_behaves_like 'compare advertiser', name: 'ВсеИнструменты', ext_id: '324'
    end
  end
end
