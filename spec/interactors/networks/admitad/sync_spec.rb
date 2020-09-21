# frozen_string_literal: true

require 'rails_helper'

describe Networks::Admitad::Sync do
  let(:limit) { 1 }
  let(:token) { Faker::Alphanumeric.alphanumeric }

  before do
    stub_const('ENV', { 'ADMITAD_WEBSITE' => 34787 })
    stub_const('Networks::Admitad::Sync::LIMIT', limit)
  end

  it { expect(ENV['ADMITAD_WEBSITE']).to eq(34787) }
  it { expect(Networks::Admitad::Sync::LIMIT).to eq(limit) }

  context 'whith stubbed responses' do
    def run_sync
      travel_to Time.zone.parse("2020-09-20T20:32:44.000Z") do
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
    end

    context 'when one of the advertisers is exists' do
      before do
        create(:advertisers_admitad, ext_id: '153')
      end

      it 'creates one advertiser and updates second' do
        run_sync
        expect(Advertiser.count).to eq(2)
      end
    end

    it "compares newly created feeds' attributes" do
      run_sync
      ['153', '324', '14216', '19088', '19116', '19174'].each do |ext_id|
        model_attributes = JSON.parse(file_fixture("syncs/models/admitad_feeds_#{ext_id}.json").read)
        feed = Feed.find_by!(ext_id: ext_id)
        feed.attributes.each do |k, v|
          next if ['id', 'advertiser_id', 'index_name'].include?(k)
          expect(v).to eq(model_attributes[k]), "expected #{v.inspect} to be eq to #{model_attributes[k].inspect} of #{k.inspect} attribute"
        end
      end
    end

    it "compares newly created advertisers' attributes" do
      run_sync
      ['153', '324'].each do |ext_id|
        model_attributes = JSON.parse(file_fixture("syncs/models/admitad_advertisers_#{ext_id}.json").read)
        advertiser = Advertiser.find_by!(ext_id: ext_id)
        advertiser.attributes.each do |k, v|
          next if ["id"].include?(k)
          expect(v).to eq(model_attributes[k]), "expected #{v.inspect} to be eq to #{model_attributes[k].inspect} of #{k.inspect} attribute"
        end
      end
    end
  end
end
