Rails.application.config.before_configuration do
  directory = Rails.root.join(ENV.fetch('FEEDS_PATH'), Rails.env)
  FileUtils.mkdir_p directory
  Rails.configuration.feeds_path = directory
end
