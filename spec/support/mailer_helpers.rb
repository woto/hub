# frozen_string_literal: true

module MailerHelpers
  def from_email
    "robot@#{ENV['DOMAIN_NAME']}"
  end
end
