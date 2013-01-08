class SourcemodPluginsController < ApplicationController

  # TODO: The random plugin should have a param called "skip" that is incremented each time we load it. That way, we can skip thru sorted lists

  before_filter :new_sourcemod_plugin, :only => [:create]

  load_and_authorize_resource

  before_action :set_sourcemod_plugin, only: [:show, :edit, :update, :destroy, :upload, :upload_submit, :phrases_file_text, :download, :clean]

  # GET /sourcemod_plugins
  # GET /sourcemod_plugins.json
  def index

    search = SourcemodPlugin.scoped

    if params[:user_id]
      @user = User.find params[:user_id]
      search = search.where(user_id: @user.id)

      unless @user.eql?(current_user)
        search = search.has_phrases
      end
    else
      search = search.has_phrases
    end

    if params[:tags]
      search = search.tagged(params[:tags])
      @tags = Tag.tokens params[:tags]
    end

    search = search.order("LOWER(sourcemod_plugins.name) ASC")

    @sourcemod_plugins = search

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

    #puts @sourcemod_plugin.tag_list.inspect

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

  def download
    authorize! :download, @sourcemod_plugin

    filename = params[:filename]
    filename ||= "#{@sourcemod_plugin.filename}.translations.zip"

    phrases = Phrase.where(id: @sourcemod_plugin.translations.english.pluck(:phrase_id))

    t = Tempfile.new("#{@sourcemod_plugin.filename}_download.zip")

    Zip::ZipOutputStream.open(t.path) do |z|

      @sourcemod_plugin.languages.each do |language|
        translations = Translation.where(phrase_id: phrases.pluck(:id)).where(language_id: language.id)

        next if translations.count == 0

        if language.english?
          z.put_next_entry "addons/sourcemod/translations/#{@sourcemod_plugin.filename}.phrases.txt"
        else
          z.put_next_entry "addons/sourcemod/translations/#{language.iso_code}/#{@sourcemod_plugin.filename}.phrases.txt"
        end

        z.puts "// Exported from SourceMod Translator"
        z.puts "// Date: #{Time.zone.now}"
        z.puts "// Language: #{language.name} (#{language.iso_code})"
        z.puts "// "
        z.puts "// To view other translations for this plugin, please visit:"
        z.puts "// http://#{request.env['HTTP_HOST']}#{sourcemod_plugin_path(@sourcemod_plugin)}"
        z.puts "//"

        z.puts "\"Phrases\""
        z.puts "{"
        z.puts ""
        translations.each do |translation|
          z.puts "\t\"#{translation.phrase.name}\""
          z.puts "\t{"
          if language.english? && translation.phrase.format
            z.puts "\t\t\"#format\"\t\"#{translation.phrase.format}\""
          end
          z.puts "\t\t\"#{language.iso_code}\"\t\"#{translation.text}\""
          z.puts "\t}"
          z.puts ""
        end
        z.puts "}"
      end

    end

    send_file t.path, type: "application/zip", 
                      disposition: "attachment", 
                      filename: filename
    t.close
  end



  def clean
    authorize! :clean, @sourcemod_plugin
    respond_to do |format|
      if @sourcemod_plugin.clean!
        format.html { redirect_to @sourcemod_plugin, notice: 'Plugin successfully cleaned.' }
      else
        format.html { redirect_to @sourcemod_plugin, notice: 'Error!' }
      end
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
      params.require(:sourcemod_plugin).permit(:name, :filename, :tag_list)
    end

    def new_sourcemod_plugin
      @sourcemod_plugin = current_user.sourcemod_plugins.new(sourcemod_plugin_params)
    end
end
