# frozen_string_literal: true

class GreetingMailer < ApplicationMailer
  def hit_back
    @email = params[:email]
    mail(to: @email)
  end
end
