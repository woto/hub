# frozen_string_literal: true

class BoostIndexing
  include ApplicationInteractor

  def call
    Indexing::YandexJob.perform_later(url: context.url)
    Indexing::GoogleJob.perform_later(url: context.url)
    Indexing::BingJob.perform_later(url: context.url)
  end
end
