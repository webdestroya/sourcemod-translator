class SourcemodPluginsController < ApplicationController

  before_filter :new_sourcemod_plugin, :only => [:create]

  load_and_authorize_resource

  before_action :set_sourcemod_plugin, only: [:show, :edit, :update, :destroy]

  # GET /sourcemod_plugins
  # GET /sourcemod_plugins.json
  def index
    @sourcemod_plugins = SourcemodPlugin.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sourcemod_plugins }
    end
  end

  # GET /sourcemod_plugins/1
  # GET /sourcemod_plugins/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sourcemod_plugin }
    end
  end

  # GET /sourcemod_plugins/new
  # GET /sourcemod_plugins/new.json
  def new
    @sourcemod_plugin = SourcemodPlugin.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sourcemod_plugin }
    end
  end

  # GET /sourcemod_plugins/1/edit
  def edit
  end

  # POST /sourcemod_plugins
  # POST /sourcemod_plugins.json
  def create

    @sourcemod_plugin = current_user.sourcemod_plugins.new(sourcemod_plugin_params)
    #@sourcemod_plugin.name = params[:sourcemod_plugin][:name]
    #@sourcemod_plugin.filename = params[:sourcemod_plugin][:filename]
    @sourcemod_plugin.load_from_file(params[:sourcemod_plugin][:file].tempfile)

    respond_to do |format|
      if @sourcemod_plugin.save
        format.html { redirect_to @sourcemod_plugin, notice: 'Sourcemod plugin was successfully created.' }
        format.json { render json: @sourcemod_plugin, status: :created, location: @sourcemod_plugin }
      else
        format.html { render action: "new" }
        format.json { render json: @sourcemod_plugin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sourcemod_plugins/1
  # PATCH/PUT /sourcemod_plugins/1.json
  def update
    respond_to do |format|
      if @sourcemod_plugin.update_attributes(sourcemod_plugin_params)
        format.html { redirect_to @sourcemod_plugin, notice: 'Sourcemod plugin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sourcemod_plugin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sourcemod_plugins/1
  # DELETE /sourcemod_plugins/1.json
  def destroy
    @sourcemod_plugin.destroy

    respond_to do |format|
      format.html { redirect_to sourcemod_plugins_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sourcemod_plugin
      @sourcemod_plugin = SourcemodPlugin.find(params[:id])
    end

    # Use this method to whitelist the permissible parameters. Example: params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def sourcemod_plugin_params
      params.require(:sourcemod_plugin).permit(:name, :filename)
    end

    def new_sourcemod_plugin
      @sourcemod_plugin = current_user.sourcemod_plugins.new(sourcemod_plugin_params)
    end
end
