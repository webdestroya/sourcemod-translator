class SourcemodPluginsController < ApplicationController

  # TODO: The random plugin should have a param called "skip" that is incremented each time we load it. That way, we can skip thru sorted lists

  before_filter :new_sourcemod_plugin, :only => [:create]

  load_and_authorize_resource

  before_filter :set_sourcemod_plugin, only: [:show, :edit, :update, :destroy, :upload, 
                                              :upload_submit, :phrases_file_text, 
                                              :download, :clean, :participation_graph,
                                              :stats
                                             ]

  # GET /sourcemod_plugins
  # GET /sourcemod_plugins.json
  def index

    @sourcemod_plugin = SourcemodPlugin.new

    @sourcemod_plugin.name = params[:name] || ''

    search = SourcemodPlugin.includes(:user)


    if !@sourcemod_plugin.name.blank?
      search = search.where(["sourcemod_plugins.name ILIKE ?", "%#{@sourcemod_plugin.name}%"])
    end

    if !params[:user_id].blank?
      @user = User.find_by_id params[:user_id]
      if @user
        search = search.where(user_id: @user.id)
    
        search = search.has_phrases unless @user.eql?(current_user)
      end
    else
      search = search.has_phrases
    end

    if !params[:tags].blank?
      search = search.tagged(params[:tags])
      @tags = Tag.tokens params[:tags]
    end

    if !params[:attempted_min].blank?
      params[:attempted_min] = params[:attempted_min].to_i
      search = search.where(["sourcemod_plugins.attempted >= ?", params[:attempted_min].to_i])
    end

    if !params[:attempted_max].blank?
      params[:attempted_max] = params[:attempted_max].to_i
      search = search.where(["sourcemod_plugins.attempted <= ?", params[:attempted_max].to_i])
    end

    if !params[:overall_min].blank?
      params[:overall_min] = params[:overall_min].to_i
      search = search.where(["sourcemod_plugins.completed >= ?", params[:overall_min].to_i])
    end

    if !params[:overall_max].blank?
      params[:overall_max] = params[:overall_max].to_i
      search = search.where(["sourcemod_plugins.completed <= ?", params[:overall_max].to_i])
    end

    search = search.order("sourcemod_plugins.attempted, LOWER(sourcemod_plugins.name) ASC")

    @sourcemod_plugins = search

    # @users = []
    # User.where("id IN (SELECT user_id FROM sourcemod_plugins)")
    # .select("id, name")
    # .order("LOWER(name) ASC")
    # .each do |user|
    #   @users << {
    #     id: user.id.to_s,
    #     text: user.name
    #   }
    # end

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

    if params[:sourcemod_plugin].nil? || params[:sourcemod_plugin][:file].nil?
      flash[:error] = "Sorry, there was a problem with your upload."
      redirect_to upload_sourcemod_plugin_path(@sourcemod_plugin) and return
    end



    ulfilename = params[:sourcemod_plugin][:file].original_filename
    phrase_count = 0
    #@sourcemod_plugin = current_user.sourcemod_plugins.find(params[:id])
    if ulfilename =~ /\.zip$/i

      zf = Zip::ZipFile.new(params[:sourcemod_plugin][:file].tempfile)
      zf.each_with_index do |entry, index|
        entry_name = entry.name
        if entry_name =~ /#{@sourcemod_plugin.filename}\.phrases\.txt$/i

          #puts "entry #{index} is #{entry.name}, size = #{entry.size}, compressed size = #{entry.compressed_size}"
          begin
            phrase_count = phrase_count + @sourcemod_plugin.load_from_file(zf.get_input_stream(entry))
          rescue
            # error
          end
        end
      end

    elsif ulfilename =~ /\.txt$/i
      phrase_count = @sourcemod_plugin.load_from_file File.open(params[:sourcemod_plugin][:file].tempfile)
    else
      render json: {status:"fail"}, status: :not_acceptable and return
    end

    respond_to do |format|
      if @sourcemod_plugin.save
        format.json { render json: {phrases: phrase_count, status:"ok"}, status: :ok }
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
            translation.phrase.format_infos.has_description.each do |fmt|
              z.puts "\t\t// #{fmt.position}: #{fmt.description}"
            end
            z.puts "\t\t\"#format\"\t\"#{translation.phrase.format}\""
          end
          z.puts "\t\t\"#{language.iso_code}\"\t\t\"#{translation.text}\""
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

  def participation_graph
    graph = PluginStat.get_statistic(@sourcemod_plugin, :participation, false)
    render :json => graph
  end

  def stats

    @top_contributers = []
    @sourcemod_plugin.translations.web
    .select("translations.user_id, count(*) as trans_count")
    .group("translations.user_id")
    .order("trans_count DESC")
    .limit(10)
    .each do |contrib|
      @top_contributers << {
        user: User.find(contrib.user_id.to_i), 
        translations: contrib.trans_count.to_i,
        percent: 100.0*(contrib.trans_count.to_f / @sourcemod_plugin.translations_count.to_f)
      }
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
