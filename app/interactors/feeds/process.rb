# frozen_string_literal: true

class Feeds::Process
  include ApplicationInteractor

  class GracefulExitError < StandardError; end
  class SkipJobError < StandardError; end
  class OffersLimitError < SkipJobError; end
  class ElasticResponseError < SkipJobError; end
  class ElasticUnexpectedNestingError < SkipJobError; end
  class FeedDisabledError < SkipJobError; end
  class DetectFileTypeError < SkipJobError; end
  class TimeoutError < SkipJobError; end
  class UnzipError < SkipJobError; end

  def call
    # Trap ^C
    Signal.trap('INT') do
      puts 'Please wait while gracefully exiting'
      raise GracefulExitError
    end

    # Trap `Kill`
    Signal.trap('TERM') do
      puts 'Please wait while gracefully exiting'
      raise GracefulExitError
    end

    loop do
      context = Feeds::PickJob.call
      Feeds::Download.call(context)
      Files::StoreFileType.call(context)
      Files::StoreXmlFilePath.call(context)
      unless Elastic::IndexExists.call(context).object
        Elastic::CreateIndex.call(context)
      end
      # Elastic::DeleteIndex.call(context)
      Feeds::Parse.call(context)
    rescue GracefulExitError => e
      context.error = e
      exit
    rescue SkipJobError => e
      context.error = e
      # nil
    ensure
      Offers::Delete.call(context)
      Feeds::ReleaseJob.call(context)
    end
  end
end
