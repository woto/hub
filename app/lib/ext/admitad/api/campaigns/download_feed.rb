# frozen_string_literal: true

module Ext
  module Admitad
    module Api
      module Campaigns
        class DownloadFeed
          include ApplicationInteractor

          def call
            Rails.logger.info('Ext::Admitad::Api::Campaigns::DownloadFeed')

            url = context.feed.url
            uri = URI(url)
            req = Net::HTTP::Get.new(uri.request_uri)
            path = context.feed.file_full_path

            File.open(path, 'wb') do |f|
              Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
                http.request(req) do |response|
                  response.value # raise error when response is not successful
                  response.read_body { |chunk| f.write(chunk) }
                end
              rescue Net::HTTPServerException => e
                # TODO: mark feed as wrong?
                raise Ext::Admitad::Api::Campaigns::Processing::SkipJobError, e.message
              rescue Net::ReadTimeout => e
                raise Ext::Admitad::Api::Campaigns::Processing::SkipJobError, e.message
              end
            end
          end
        end
      end
    end
  end
end

# I, [2020-07-14T06:03:47.160035 #44397]  INFO -- : {"_id"=>BSON::ObjectId('5f0d154fefd9fba9f434e583'), "id"=>6115, "name"=>"AliExpress WW", "feeds_info"=>[{"advertiser_last_update"=>"2020-07-14 01:52:47", "admitad_last_update"=>"2020-07-14 01:52:47", "csv_link"=>"http://export.admitad.com/ru/webmaster/websites/599023/products/export_adv_products/?user=woto&code=6ad3cb74b8&feed_id=14267&format=csv", "name"=>"10-25$", "xml_link"=>"http://export.admitad.com/ru/webmaster/websites/599023/products/export_adv_products/?user=woto&code=6ad3cb74b8&feed_id=14267&format=xml", "processing"=>false, "processing_finished_at"=>2020-07-14 03:03:47 UTC, "processing_started_at"=>2020-07-14 02:25:59 UTC, "uuid"=>"ae4976d4-9a82-4a90-a49e-39be6c54af7b", "error"=>nil}]}
# I, [2020-07-14T06:03:47.160170 #44397]  INFO -- : Job released
# D, [2020-07-14T06:03:47.160336 #44397] DEBUG -- : Validation failed: Feedcategory cannot be a descendant of itself. excluded from capture: No host specified, no public_key specified, no project_id specified
# rake aborted!
# ActiveRecord::RecordInvalid: Validation failed: Feedcategory cannot be a descendant of itself.
#     /Users/r.kornev/work/_/hub/app/lib/ext/admitad/api/campaigns/link_feed_categories.rb:15:in `block in call'
# /Users/r.kornev/work/_/hub/app/lib/ext/admitad/api/campaigns/link_feed_categories.rb:11:in `call'
# /Users/r.kornev/work/_/hub/app/lib/ext/admitad/api/campaigns/process_feed.rb:58:in `call'
# /Users/r.kornev/work/_/hub/app/lib/ext/admitad/api/campaigns/process.rb:34:in `block in call'
# /Users/r.kornev/work/_/hub/app/lib/ext/admitad/api/campaigns/process.rb:29:in `loop'
# /Users/r.kornev/work/_/hub/app/lib/ext/admitad/api/campaigns/process.rb:29:in `call'
# /Users/r.kornev/work/_/hub/lib/tasks/admitad.rake:16:in `block (3 levels) in <top (required)>'
# /Users/r.kornev/.rbenv/versions/2.5.7/bin/bundle:23:in `load'
# /Users/r.kornev/.rbenv/versions/2.5.7/bin/bundle:23:in `<main>'
# Tasks: TOP => admitad:campaigns:process
# (See full trace by running task with --trace)
