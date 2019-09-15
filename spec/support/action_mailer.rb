# frozen_string_literal: true

# https://thoughtbot.com/blog/action-mailer-and-active-job-sitting-in-a-tree
RSpec.configure do |config|
  config.before do
    ActionMailer::Base.deliveries.clear
  end
end
