# frozen_string_literal: true

module Widgets
  class SimplesController < ApplicationController
    before_action :set_widgets_simple, only: %i[ show edit update destroy ]
    layout false

    def new
      @widgets_simple = Widgets::Simple.new(widget: Widget.new)
      authorize(@widgets_simple)

      # @widgets_simple.pictures.attach(io: URI.parse('https://via.placeholder.com/250x400').open, filename: 'foo.png')
      # @widgets_simple.pictures.attach(ActiveStorage::Blob.first)
    end

    def edit
      authorize(@widgets_simple)
    end

    def create
      @widgets_simple = Widgets::Simple.new(widgets_simple_params)
      @widgets_simple.build_widget(user: current_user)
      authorize(@widgets_simple)

      respond_to do |format|
        if @widgets_simple.save
          format.html { redirect_to edit_widgets_simple_path(@widgets_simple), notice: t('.simple_was_successfully_created') }
          format.json { render :show, status: :created, location: @widgets_simple }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @widgets_simple.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /widgets/simples/1 or /widgets/simples/1.json
    def update
      authorize(@widgets_simple)
      respond_to do |format|
        if @widgets_simple.update(widgets_simple_params)
          format.html { redirect_to edit_widgets_simple_path(@widgets_simple), notice: t('.simple_was_successfully_updated') }
          format.json { render :show, status: :ok, location: @widgets_simple }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @widgets_simple.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_widgets_simple
      @widgets_simple = Widgets::Simple.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def widgets_simple_params
      params.require(:widgets_simple).permit(:title, :url, :body, pictures: [])
    end
  end
end
