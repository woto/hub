class RobotMailbox < ApplicationMailbox
  def process
    GreetingMailer.with(email: mail.from).hit_back.deliver_later
  end
end
