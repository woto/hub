# frozen_string_literal: true

require 'rails_helper'

describe OffersController, type: :request do
  before(:all) do
    Staff::Cropper::Elastic.crop
    Staff::Seeder::Elastic.pagination
  end

  it 'Is simply works :)' do
    get '/feeds/zero_my_index_name/offers?page=1&q=one_my_offer_name'
    assert_select 'h1[jid="name"]', count: 1, text: '[one] [my_offer_name] one_my_offer_name'
  end

  it 'Is simple works too :)' do
    get '/offers?page=1'
    assert_select 'h1[jid="name"]', count: 10
  end
end
