# frozen_string_literal: true

class HomepageController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render template: "layouts/homepage", layout: false
  end
end
