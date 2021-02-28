# frozen_string_literal: true

class Import::Process
  include ApplicationInteractor

  class SkipJobError < StandardError; end
  class OffersLimitError < SkipJobError; end
  class ElasticResponseError < SkipJobError; end
  class ElasticUnexpectedNestingError < SkipJobError; end
  class HTTPServerException < SkipJobError; end
  class ReadTimeout < SkipJobError; end
  class DetectFileTypeError < SkipJobError; end
  class UnzipError < SkipJobError; end
  class UnknownFileType < SkipJobError; end

  def call
    result = Import::LockFeed.call(feed: context.feed)
    return if result.failure?

    feed = result.object
    Import::DownloadFeed.call(feed: feed)
    Import::DetectFileType.call(feed: feed)
    Import::Preprocess.call(feed: feed)
    Feeds::Parse.call(feed: feed)
  rescue SkipJobError => e
    error = e
  ensure
    Import::DeleteOldOffers.call(feed: feed)
    Import::ReleaseFeed.call(feed: feed, error: error)
    Elastic::RefreshOffersIndex.call
    Import::AggregateLanguage.call(feed: feed)
  end
end
