# frozen_string_literal: true

class HomepageController < ApplicationController
  # skip_after_action :verify_policy_scoped
  skip_before_action :authenticate_user!

  def index
    render template: "layouts/homepage", layout: false
  end
end
