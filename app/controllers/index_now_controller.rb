# frozen_string_literal: true

class IndexNowController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    render plain: ENV.fetch('INDEX_NOW_KEY')
  end
end
