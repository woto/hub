# frozen_string_literal: true

require 'rails_helper'

describe 'GET /swagger_doc' do
  it 'returns returns API spec without authentication' do
    get '/swagger_doc'
    expect(JSON.parse(response.body)).to include({
                                                   'info' => a_kind_of(Hash),
                                                   'swagger' =>	'2.0',
                                                   'produces' =>	a_kind_of(Array),
                                                   'securityDefinitions' =>	a_kind_of(Hash),
                                                   #  'security' =>	a_kind_of(Array),
                                                   'host' =>	a_kind_of(String),
                                                   'tags' =>	a_kind_of(Array),
                                                   'paths' =>	a_kind_of(Hash)
                                                 })
  end
end
