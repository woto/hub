# frozen_string_literal: true

class EmbedsController < ApplicationController
  def show
    @embed = Embed.new(offer_url: params[:url], embed_type: params[:type])
    render json: {
      sgid: @embed.attachable_sgid,
      content: render_to_string('embeds/show', locals: { embed: @embed }, formats: [:html])
    }
  end
end
