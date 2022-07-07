# frozen_string_literal: true

module Interactors
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
            required(:params).array(:hash) do
              required(:id)
              required(:destroy)
              required(:title)
            end
          end
        end

        def call
          without_ids, with_ids = params.partition { |lookup_params| lookup_params['id'].blank? }

          without_ids.each do |lookup_params|
            next if lookup_params['title'].blank?

            lookup = Lookup.create!(title: lookup_params['title'], user: user)
            LookupsRelation.create!(lookup: lookup, relation: cite, user: user)
            LookupsRelation.create!(lookup: lookup, relation: entity, user: user)
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
              replaced_lookup = Lookup.create!(title: lookup_params['title'], user: user)
              LookupsRelation.create!(lookup: replaced_lookup, relation: cite, user: user)
              LookupsRelation.create!(lookup: replaced_lookup, relation: entity, user: user)
            else
              LookupsRelation.create!(lookup: matched_lookup, relation: cite, user: user)
            end
          end
        end
      end
    end
  end
end