# frozen_string_literal: true

class Template1sController < ApplicationController
  before_action :set_template1, only: %i[show edit update destroy]

  # GET /template1s
  # GET /template1s.json
  def index
    @template1s = Template1.all
  end

  # GET /template1s/1
  # GET /template1s/1.json
  def show; end

  # GET /template1s/new
  def new
    @template1 = Template1.new
  end

  # GET /template1s/1/edit
  def edit; end

  # POST /template1s
  # POST /template1s.json
  def create
    @template1 = Template1.new(template1_params)

    respond_to do |format|
      if @template1.save
        format.html { redirect_to @template1, notice: 'Template1 was successfully created.' }
        format.json { render :show, status: :created, location: @template1 }
      else
        format.html { render :new }
        format.json { render json: @template1.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /template1s/1
  # PATCH/PUT /template1s/1.json
  def update
    respond_to do |format|
      if @template1.update(template1_params)
        format.html { redirect_to @template1, notice: 'Template1 was successfully updated.' }
        format.json { render :show, status: :ok, location: @template1 }
      else
        format.html { render :edit }
        format.json { render json: @template1.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /template1s/1
  # DELETE /template1s/1.json
  def destroy
    @template1.destroy
    respond_to do |format|
      format.html { redirect_to template1s_url, notice: 'Template1 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_template1
    @template1 = Template1.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def template1_params
    params.require(:template1).permit(:name, :gender)
  end
end
