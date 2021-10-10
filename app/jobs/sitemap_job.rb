# frozen_string_literal: true

class SitemapJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    SitemapGenerator::Interpreter.run
  end
end
