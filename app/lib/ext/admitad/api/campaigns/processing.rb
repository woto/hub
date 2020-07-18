# frozen_string_literal: true

module Ext
  module Admitad
    module Api
      module Campaigns
        class Processing
          include ApplicationInteractor

          class GracefulExitError < StandardError; end
          class SkipJobError < StandardError; end

          def call
            Rails.logger.info('Ext::Admitad::Api::Campaigns:Processing')

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
              context = Ext::Admitad::Api::Campaigns::GetJob.call
              Ext::Admitad::Api::Campaigns::DownloadFeed.call(context)
              Ext::Admitad::Api::Campaigns::ParseFeed.call(context)
            rescue GracefulExitError => e
              context.error = e&.full_message
              exit
            rescue SkipJobError => e
              context.error = e&.full_message
              nil
            ensure
              Ext::Admitad::Api::Campaigns::ReleaseJob.call(context)
            end
          end
        end
      end
    end
  end
end
