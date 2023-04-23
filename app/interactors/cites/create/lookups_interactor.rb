# frozen_string_literal: true

module Cites
  module Create
    class LookupsInteractor
      include ApplicationInteractor
      delegate :cite, :entity, :user, :params, to: :context

      contract do
        params do
          config.validate_keys = true
          required(:cite)
          required(:entity)
          required(:user)
          required(:params).maybe do
            array(:hash) do
              required(:id)
              required(:destroy)
              required(:title)
            end
          end
        end
      end

      def call
        return if params.nil?

        without_ids, with_ids = params.partition { |lookup_params| lookup_params['id'].blank? }

        without_ids.each do |lookup_params|
          next if lookup_params['title'].blank?

          lookup = Lookup.create!(title: lookup_params['title'], user:)
          LookupsRelation.create!(lookup:, relation: cite, user:)
          LookupsRelation.create!(lookup:, relation: entity, user:)
        end

        lookups = Lookup.find(with_ids.map { |item| item['id'] })

        with_ids.each do |lookup_params|
          matched_lookup = lookups.find { |item| item.id == lookup_params['id'] }

          if lookup_params['destroy']
            lookups_relation = LookupsRelation.find_by(lookup: matched_lookup, relation: entity)
            lookups_relation.destroy!
          elsif matched_lookup.title != lookup_params['title']
            lookups_relation = LookupsRelation.find_by(lookup: matched_lookup, relation: entity)
            lookups_relation.destroy!
            replaced_lookup = Lookup.create!(title: lookup_params['title'], user:)
            LookupsRelation.create!(lookup: replaced_lookup, relation: cite, user:)
            LookupsRelation.create!(lookup: replaced_lookup, relation: entity, user:)
          else
            LookupsRelation.create!(lookup: matched_lookup, relation: cite, user:)
          end
        end
      end
    end
  end
end
