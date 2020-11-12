# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "robot@#{ENV['DOMAIN_NAME']}"
  layout 'mailer'
end
