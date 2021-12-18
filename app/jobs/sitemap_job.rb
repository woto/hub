# frozen_string_literal: true

class SitemapJob < ApplicationJob
  queue_as :default

  def perform(file_name)
    SitemapGenerator::Interpreter.run(config_file: File.join(SitemapGenerator.app.root, "config", file_name))
  end
end
