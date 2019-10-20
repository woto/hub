# frozen_string_literal: true

class OffersController < ApplicationController
  def index
    @result = Elastic.call(params)
  end
end
