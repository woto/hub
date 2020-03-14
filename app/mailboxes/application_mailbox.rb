class ApplicationMailbox < ActionMailbox::Base
  routing /^robot@/i     => :robot
end
