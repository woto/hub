Rails.logger = Logger.new(STDOUT)

namespace :admitad do

  namespace :campaigns do
    desc "Sync camapaigns list"
    task sync: :environment do
      context = Ext::Admitad::Api::Token::Restore.call
      context = Ext::Admitad::Api::Token::Retrive.call if context.failure?
      Ext::Admitad::Api::Campaigns::Sync.call(context)
      Rails.logger.debug("Finished")
    end

    desc "Download and process feeds"
    task process: :environment do
      Ext::Admitad::Api::Campaigns::Processing.call
    end
  end
end
