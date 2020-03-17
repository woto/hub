# frozen_string_literal: true

# https://thoughtbot.com/blog/action-mailer-and-active-job-sitting-in-a-tree
RSpec.configure do |config|
  config.include ActiveJob::TestHelper

  config.before do
    clear_enqueued_jobs
  end
end
