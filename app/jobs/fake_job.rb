# frozen_string_literal: true

class FakeJob < ApplicationJob
  include Sidekiq::Util

  def perform(*_args)
    puts "#{identity}:#{tid}"
    sleep rand(10)
  end
end

