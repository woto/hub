# frozen_string_literal: true

module Import
  class ProcessInteractor
    include ApplicationInteractor

    class SkipJobError < StandardError; end
    class OffersLimitError < SkipJobError; end
    class ElasticResponseError < SkipJobError; end
    class ElasticUnexpectedNestingError < SkipJobError; end
    class HTTPServerException < SkipJobError; end
    class ReadTimeout < SkipJobError; end
    class BadRequestError < SkipJobError; end
    class DetectFileTypeError < SkipJobError; end
    class UnzipError < SkipJobError; end
    class UnknownFileType < SkipJobError; end

    def call
      result = Import::LockFeedInteractor.call(feed: context.feed)
      return if result.failure?

      feed = result.object
      Import::DownloadFeedInteractor.call(feed:)
      Import::DetectFileTypeInteractor.call(feed:)
      Import::PreprocessInteractor.call(feed:)
      Feeds::ParseInteractor.call(feed:)
    rescue SkipJobError => e
      error = e
    ensure
      Import::DeleteOldOffersInteractor.call(feed:)
      Import::ReleaseFeedInteractor.call(feed:, error:)
      Elastic::RefreshOffersIndexInteractor.call
      Import::AggregateLanguageInteractor.call(feed:)
    end
  end
end
