class RobotMailbox < ApplicationMailbox
  def process
    GreetingMailer.with(user: mail.from).hit_back.deliver_later
  end
end
