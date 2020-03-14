class RobotMailbox < ApplicationMailbox
  def process
    GreetingMailer.hit_back(user: mail.from)
  end
end
