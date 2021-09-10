# frozen_string_literal: true

class Landing1Controller < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render template: "layouts/landing1", layout: false
  end
end
