class SitemapJob < ApplicationJob
  queue_as :default

  def perform(*args)
    SitemapGenerator::Interpreter.run
  end
end
