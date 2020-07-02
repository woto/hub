# frozen_string_literal: true

class ApplicationMailbox < ActionMailbox::Base
  routing(/^robot@/i => :robot)
end
