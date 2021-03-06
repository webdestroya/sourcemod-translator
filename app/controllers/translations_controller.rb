class TranslationsController < ApplicationController

  # TODO: If they try to add a translation when there are no valid languages, we should error

  before_filter :new_translation, :only => [:create]

  load_and_authorize_resource

  before_filter :set_translation, only: [:show, :edit, :update, :destroy]

  # GET /translations
  # GET /translations.json
  def index
    tran_search = Translation.web.includes(:language, :phrase)
    if params[:user_id]
      @user = User.find params[:user_id]
      tran_search = tran_search.where(user_id: params[:user_id].to_i)
    end
    tran_search = tran_search.order("translations.created_at DESC")

    @translations = tran_search.limit(50)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @translations }
    end
  end

  # GET /translations/1
  # GET /translations/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @translation }
    end
  end

  # GET /translations/new
  # GET /translations/new.json
  def new
    @phrase = Phrase.find params[:phrase_id]
    @translation = @phrase.translations.new

    finished_lang_ids = @phrase.languages.collect{|o|o.id}

    @languages = current_user.languages.where(["languages.id NOT IN (?)", finished_lang_ids]).order("LOWER(name) ASC")

    if params[:plugin_id]
      @plugin = SourcemodPlugin.find params[:plugin_id].to_i
    end

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /translations/1/edit
  def edit
  end

  # POST /translations
  # POST /translations.json
  def create
    @translation = current_user.translations.new(translation_params)
    @phrase = @translation.phrase
    finished_lang_ids = @phrase.languages.collect{|o|o.id}

    @languages = current_user.languages.where(["languages.id NOT IN (?)", finished_lang_ids]).order("LOWER(name) ASC")

    if params[:plugin_id]
      @plugin = SourcemodPlugin.find params[:plugin_id].to_i
    end


    respond_to do |format|
      if @translation.save

        redirect_path = phrase_path(@translation.phrase)
        redirect_path = random_translations_path(:plugin_id => params[:plugin_id]) if params[:random]

        format.html { redirect_to redirect_path, notice: 'Translation was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PATCH/PUT /translations/1
  # PATCH/PUT /translations/1.json
  def update
    respond_to do |format|
      if @translation.update_attributes(translation_params)
        format.html { redirect_to @translation, notice: 'Translation was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /translations/1
  # DELETE /translations/1.json
  def destroy
    @translation.destroy

    respond_to do |format|
      format.html { redirect_to @translation.phrase, notice: "Translation deleted" }
    end
  end

  # This will show an edit page for a random translation
  # This requires a user with languages
  # and searches for phrases that are missing translations in the language this user
  # knows
  def random
    if current_user.nil?
      flash[:error] = "You must be logged in!"
      redirect_to sourcemod_plugins_path and return
    end

    langs = current_user.languages.collect{|o|o.id}

    if langs.empty?
      flash[:error] = "You must add some languages!"
      redirect_to languages_path and return
    end

    # they only want randoms for a specific plugin
    if params[:plugin_id]
      @plugin = SourcemodPlugin.find params[:plugin_id].to_i
    end

    phrase_search = Phrase.scoped
    phrase_search = phrase_search.needs_translation(current_user.languages)

    phrase_search = phrase_search.plugin(@plugin) if @plugin
    
    phrase_search = phrase_search.order("phrases.translations_count DESC")
    
    phrases = phrase_search.limit(100).collect{|o|o.id}

    if phrases.size > 0

      options = {}
      options[:random] = 1
      options[:plugin_id] = params[:plugin_id] if @plugin

      phrases.shuffle!
      phrase = Phrase.find(phrases[0])
      redirect_to new_phrase_translation_path(phrase, options) and return      
    end

    flash[:alert] = "Sorry, we couldn't find any phrases that you can translate :("
    redirect_to sourcemod_plugins_path and return
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_translation
      @translation = Translation.find(params[:id])
    end

    # Use this method to whitelist the permissible parameters. Example: params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def translation_params
      params.require(:translation).permit(:phrase_id, :language_id, :text)
    end

    def new_translation
      @translation = current_user.translations.new(translation_params)
    end
end
