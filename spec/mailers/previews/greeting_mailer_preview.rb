# frozen_string_literal: true

class GreetingMailerPreview < ActionMailer::Preview
  def hit_back
    GreetingMailer.with(email: 'foo@bar.com').hit_back
  end
end
