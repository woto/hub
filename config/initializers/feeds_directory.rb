# frozen_string_literal: true

Rails.application.config.before_configuration do
  directory = Rails.root.join('data', 'feeds', Rails.env)
  FileUtils.mkdir_p directory
  Rails.configuration.feeds_path = directory
end
