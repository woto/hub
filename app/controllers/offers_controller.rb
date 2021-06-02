# frozen_string_literal: true

class OffersController < ApplicationController
  skip_before_action :authenticate_user!
  layout false

  def modal_card
    result = GlobalHelper.elastic_client.get(
      index: Elastic::IndexName.offers, id: params[:id], routing: params[:id].split('-').last
    )
    @offer = OfferDecorator.new(result)

    respond_to do |format|
      format.json
    end
  end
end
