class GreetingMailer < ApplicationMailer
  def hit_back
    @email = params[:email]
    mail(to: @email, subject: 'Greeting!')
  end
end
