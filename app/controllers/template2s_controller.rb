# frozen_string_literal: true

class Template2sController < ApplicationController
  before_action :set_template2, only: %i[show edit update destroy]

  # GET /template2s
  def index
    @template2s = Template2.all
  end

  # GET /template2s/1
  def show; end

  # GET /template2s/new
  def new
    @template2 = Template2.new
  end

  # GET /template2s/1/edit
  def edit; end

  # POST /template2s
  def create
    @template2 = Template2.new(template2_params)

    if @template2.save
      redirect_to @template2, notice: 'Template2 was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /template2s/1
  def update
    if @template2.update(template2_params)
      redirect_to @template2, notice: 'Template2 was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /template2s/1
  def destroy
    @template2.destroy
    redirect_to template2s_url, notice: 'Template2 was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_template2
    @template2 = Template2.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def template2_params
    params.require(:template2).permit(:name, :gender, :foo)
  end
end
