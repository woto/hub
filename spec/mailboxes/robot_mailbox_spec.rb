require 'rails_helper'

describe RobotMailbox, type: :mailbox do
  subject do
    receive_inbound_email_from_mail(
      from: 'from-address@example.com',
      to: 'robot@nv6.ru',
      subject: 'Sample Subject',
      body: "I'm a sample body"
    )
  end

  specify do
    expect { subject }.to have_enqueued_job(ActionMailer::MailDeliveryJob).with do |**args|
      expect(args[:params][:email]).to eq(["from-address@example.com"])
    end
  end
end
