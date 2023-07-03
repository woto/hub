# frozen_string_literal: true

module Cites
  class CreateInteractor
    include ApplicationInteractor
    include AfterCommitEverywhere
    delegate :current_user, :params, to: :context

    def call
      fragment = Fragment::Parser.call(fragment_url: params[:fragment_url])

      ActiveRecord::Base.transaction do
        @entity = create_entity
        @mention = create_mention(fragment) if fragment.url.present?
        @cite = create_cite(fragment, @mention, @entity)
        create_related_records

        after_commit do
          reindex_records
          ping_crawlers
          scrape_webpage
        end
      end

      context.object = {
        # DEPRECATED: remove later (after publishing new version of extension)
        title: @entity.title,
        # DEPRECATED: remove later (after publishing new version of extension)
        entity_title: @entity.title,
        mention_title: @mention&.title,
        url: Rails.application.routes.url_helpers.entity_path(
          id: @entity,
          host: GlobalHelper.host
        ),
        entity_url: Rails.application.routes.url_helpers.entity_path(
          id: @entity,
          host: GlobalHelper.host
        ),
        mention_url: @mention && Rails.application.routes.url_helpers.mention_path(
          id: @mention,
          host: GlobalHelper.host
        ),
      }
    end

    private

    def ping_crawlers
      BoostIndexingInteractor.call(
        url: Rails.application.routes.url_helpers.entity_url(
          id: @entity,
          host: GlobalHelper.host
        )
      )
    end

    def create_related_records
      Create::ImagesInteractor.call(cite: @cite, entity: @entity, params: params[:images], user: current_user)
      Create::TopicsInteractor.call(cite: @cite, entity: @entity, params: params[:kinds], user: current_user)
      Create::LookupsInteractor.call(cite: @cite, entity: @entity, params: params[:lookups], user: current_user)
      Create::AggregateInteractor.call(entity: @entity, mention: @mention) if @mention
    end

    def reindex_records
      Elasticsearch::IndexJob.perform_later(@cite)
      Elasticsearch::IndexJob.perform_later(@entity)
      Elasticsearch::IndexJob.perform_now(@mention) if @mention
    end

    def scrape_webpage
      return unless @mention

      ::Mentions::IframelyJob.perform_later(mention_id: @mention.id, mention_url: @mention.url)
      ::Mentions::ScrapperJob.perform_later(mention_id: @mention.id, mention_url: @mention.url,
                                            user_id: current_user.id)
    end

    def create_mention(fragment)
      mention = Mention.find_by(url: fragment.url)
      mention ||= current_user.mentions.new(url: fragment.url)
      mention.save!
      mention
    end

    def create_entity
      entity = if params[:entity_id].present?
                 Entity.find(params[:entity_id])
               else
                 Entity.new
               end

      entity.user = current_user if entity.user.blank?
      entity.update!(title: params[:title], intro: params[:intro])
      entity
    end

    def create_cite(fragment, mention, entity)
      first_text = fragment.texts.first

      current_user.cites.create!(
        entity:,
        mention:,
        title: params[:title],
        intro: params[:intro],

        text_start: first_text&.text_start,
        text_end: first_text&.text_end,
        prefix: first_text&.prefix,
        suffix: first_text&.suffix,

        link_url: params[:link_url],

        relevance: params[:relevance],
        sentiment: params[:sentiment],
        mention_date: params[:mention_date]
      )
    end
  end
end
