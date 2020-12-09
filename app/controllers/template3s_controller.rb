class Template3sController < ApplicationController
  before_action :set_template3, only: [:show, :edit, :update, :destroy]

  # GET /template3s
  # GET /template3s.json
  def index
    @template3s = Template3.all
  end

  # GET /template3s/1
  # GET /template3s/1.json
  def show
  end

  # GET /template3s/new
  def new
    @template3 = Template3.new
  end

  # GET /template3s/1/edit
  def edit
  end

  # POST /template3s
  # POST /template3s.json
  def create
    @template3 = Template3.new(template3_params)

    respond_to do |format|
      if @template3.save
        format.html { redirect_to @template3, notice: 'Template3 was successfully created.' }
        format.json { render :show, status: :created, location: @template3 }
      else
        format.html { render :new }
        format.json { render json: @template3.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /template3s/1
  # PATCH/PUT /template3s/1.json
  def update
    respond_to do |format|
      if @template3.update(template3_params)
        format.html { redirect_to @template3, notice: 'Template3 was successfully updated.' }
        format.json { render :show, status: :ok, location: @template3 }
      else
        format.html { render :edit }
        format.json { render json: @template3.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /template3s/1
  # DELETE /template3s/1.json
  def destroy
    @template3.destroy
    respond_to do |format|
      format.html { redirect_to template3s_url, notice: 'Template3 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template3
      @template3 = Template3.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def template3_params
      params.require(:template3).permit(:title)
    end
end
