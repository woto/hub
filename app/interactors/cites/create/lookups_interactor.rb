# frozen_string_literal: true

module Cites
  module Create
    class LookupsInteractor
      include ApplicationInteractor

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
        return if context.params.nil?

        without_ids, with_ids = context.params.partition { |lookup_params| lookup_params[:id].blank? }

        without_ids.each do |lookup_params|
          next if lookup_params[:title].blank?

          lookup = Lookup.create!(title: lookup_params[:title], user: context.user)
          LookupsRelation.create!(lookup:, relation: context.cite, user: context.user)
          LookupsRelation.create!(lookup:, relation: context.entity, user: context.user)
        end

        lookups = Lookup.find(with_ids.map { |item| item[:id] })

        with_ids.each do |lookup_params|
          matched_lookup = lookups.find { |item| item.id == lookup_params[:id] }

          if lookup_params[:destroy]
            lookups_relation = LookupsRelation.find_by(lookup: matched_lookup, relation: context.entity)
            lookups_relation.destroy!
          elsif matched_lookup.title != lookup_params[:title]
            lookups_relation = LookupsRelation.find_by(lookup: matched_lookup, relation: context.entity)
            lookups_relation.destroy!
            replaced_lookup = Lookup.create!(title: lookup_params[:title], user: context.user)
            LookupsRelation.create!(lookup: replaced_lookup, relation: context.cite, user: context.user)
            LookupsRelation.create!(lookup: replaced_lookup, relation: context.entity, user: context.user)
          else
            LookupsRelation.create!(lookup: matched_lookup, relation: context.cite, user: context.user)
          end
        end
      end
    end
  end
end
