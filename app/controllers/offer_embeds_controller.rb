# frozen_string_literal: true

class OfferEmbedsController < ApplicationController

  def create
    @offer_embed = policy_scope(OfferEmbed).create!(get_offer)

    render json: {
        sgid: @offer_embed.attachable_sgid,
        content: render_to_string('offer_embeds/show', locals: { offer_embed: @offer_embed }, formats: [:html])
    }

    # @offer_embed = policy_scope(OfferEmbed).from_attachable_sgid(params[:id])
    # @offer_embed.update!(urls: params[:urls])
    # @offer_embed = GlobalID::Locator.locate_signed(params[:id], for: 'attachable')
  end

  def get_offer
    @get_offer ||= GlobalHelper.get_offer(params[:ext_id])
  end
end
