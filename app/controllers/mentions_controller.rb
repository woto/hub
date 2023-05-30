# frozen_string_literal: true

class MentionsController < ApplicationController
  layout 'roastme/pages'

  before_action :set_mention, only: %i[show]
  skip_before_action :authenticate_user!, only: [:show, :index]

  # GET /mention/:id
  def show
    seo.langs! { |l| mention_url(@mention, locale: l) }
    seo.canonical! mention_url(@mention)

    # @draft = ::Mentions::IndexInteractor.call(
    #   current_user:,
    #   params: { mention_id: params[:id] }
    # ).object
  end

  # GET /mentions
  def index
    # seo.noindex!

    # @draft = ::Mentions::IndexInteractor.call(
    #   current_user:,
    #   params: {}
    # ).object
  end

  private

  # # Use callbacks to share common setup or constraints between actions.
  def set_mention
    @mention = Mention.find(params[:id])
  end
end
