# frozen_string_literal: true

class WidgetsController < ApplicationController
  before_action :set_widgets, only: %i[show edit update destroy]

  def index
    @widgets = policy_scope(Widget).order(updated_at: :desc).page(params[:page]).per(10)
    authorize(:widget)

    respond_to do |format|
      format.json
      format.html
    end
  end

  def show
    authorize(@widget)
    respond_to do |format|
      format.json
    end
  end

  def new
    authorize(:widget, :new?)
    render layout: false
  end

  # ActiveModel implementation (stateless)
  # @offer_embed = policy_scope(OfferEmbed).from_attachable_sgid(params[:id])
  # @offer_embed.update!(urls: params[:urls])
  # @offer_embed = GlobalID::Locator.locate_signed(params[:id], for: 'attachable')
  # ActionController::Base.render(partial: 'offer_embeds/offer_embed', locals: { offer_embed: OfferEmbed.last }, formats: [:html])

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_widgets
    @widget = Widget.find(params[:id])
  end
end
