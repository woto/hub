# frozen_string_literal: true

module API
  class Offers < ::Grape::API
    prefix :api

    resource :mentions do
      params do
        optional :q, type: String, desc: 'Search string', documentation: { param_type: 'body' }
        optional :entity_ids, type: Array[Integer]
        optional :per
        optional :page
        optional :sort
      end
