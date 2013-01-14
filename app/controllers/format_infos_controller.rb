class FormatInfosController < ApplicationController
  before_filter :set_format_info, only: [:show, :edit, :update, :destroy]

  # GET /format_infos
  # GET /format_infos.json
  def index
    @format_infos = FormatInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @format_infos }
    end
  end

  # GET /format_infos/1
  # GET /format_infos/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @format_info }
    end
  end

  # GET /format_infos/new
  # GET /format_infos/new.json
  def new
    @format_info = FormatInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @format_info }
    end
  end

  # GET /format_infos/1/edit
  def edit
  end

  # POST /format_infos
  # POST /format_infos.json
  def create
    @format_info = FormatInfo.new(format_info_params)

    respond_to do |format|
      if @format_info.save
        format.html { redirect_to @format_info, notice: 'Format info was successfully created.' }
        format.json { render json: @format_info, status: :created, location: @format_info }
      else
        format.html { render action: "new" }
        format.json { render json: @format_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /format_infos/1
  # PATCH/PUT /format_infos/1.json
  def update
    respond_to do |format|
      if @format_info.update_attributes(format_info_params)
        format.html { redirect_to @format_info, notice: 'Format info was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @format_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /format_infos/1
  # DELETE /format_infos/1.json
  def destroy
    @format_info.destroy

    respond_to do |format|
      format.html { redirect_to format_infos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_format_info
      @format_info = FormatInfo.find(params[:id])
    end

    # Use this method to whitelist the permissible parameters. Example: params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def format_info_params
      params.require(:format_info).permit(:phrase_id, :position, :format_class, :description)
    end
end
