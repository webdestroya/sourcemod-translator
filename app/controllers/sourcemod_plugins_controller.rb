class SourcemodPluginsController < ApplicationController

  before_filter :new_sourcemod_plugin, :only => [:create]

  load_and_authorize_resource

  before_action :set_sourcemod_plugin, only: [:show, :edit, :update, :destroy, :upload, :upload_submit, :phrases_file_text]

  # GET /sourcemod_plugins
  # GET /sourcemod_plugins.json
  def index
    if params[:user_id]
      @user = User.find params[:user_id]
      @sourcemod_plugins = @user.sourcemod_plugins.order("LOWER(name) ASC").all
    else
      @sourcemod_plugins = SourcemodPlugin.has_phrases.order("LOWER(name) ASC").all
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /sourcemod_plugins/1
  # GET /sourcemod_plugins/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /sourcemod_plugins/new
  # GET /sourcemod_plugins/new.json
  def new
    @sourcemod_plugin = SourcemodPlugin.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /sourcemod_plugins/1/edit
  def edit
  end

  # POST /sourcemod_plugins
  # POST /sourcemod_plugins.json
  def create

    @sourcemod_plugin = current_user.sourcemod_plugins.new(sourcemod_plugin_params)

    respond_to do |format|
      if @sourcemod_plugin.save
        format.html { redirect_to @sourcemod_plugin, notice: 'Plugin was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PATCH/PUT /sourcemod_plugins/1
  # PATCH/PUT /sourcemod_plugins/1.json
  def update
    respond_to do |format|
      if @sourcemod_plugin.update_attributes(sourcemod_plugin_params)
        format.html { redirect_to @sourcemod_plugin, notice: 'Plugin was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /sourcemod_plugins/1
  # DELETE /sourcemod_plugins/1.json
  def destroy
    @sourcemod_plugin.destroy

    respond_to do |format|
      format.html { redirect_to sourcemod_plugins_url }
    end
  end



  def upload
    authorize! :upload, @sourcemod_plugin
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def upload_submit
    authorize! :upload, @sourcemod_plugin

    ulfilename = params[:sourcemod_plugin][:file].original_filename
    #@sourcemod_plugin = current_user.sourcemod_plugins.find(params[:id])
    if ulfilename =~ /\.zip$/i

      zf = Zip::ZipFile.new(params[:sourcemod_plugin][:file].tempfile)
      zf.each_with_index do |entry, index|
        entry_name = entry.name
        if entry_name =~ /#{@sourcemod_plugin.filename}\.phrases\.txt$/i

          #puts "entry #{index} is #{entry.name}, size = #{entry.size}, compressed size = #{entry.compressed_size}"
          @sourcemod_plugin.load_from_file zf.get_input_stream(entry)
        end
      end

    elsif ulfilename =~ /\.txt$/i
      @sourcemod_plugin.load_from_file File.open(params[:sourcemod_plugin][:file].tempfile)
    else
      # error
    end

    respond_to do |format|
      if @sourcemod_plugin.save
        format.html { redirect_to upload_sourcemod_plugin_path(@sourcemod_plugin), notice: 'Phrase file uploaded!' }
      else
        format.html { render action: "upload" }
      end
    end
  end

  def export
    authorize! :export, @sourcemod_plugin
    respond_to do |format|
      format.text { render }
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
