class PhrasesController < ApplicationController
  load_and_authorize_resource

  before_filter :set_phrase, only: [:show, :edit, :update, :destroy, :translate, :translate_submit]

  # GET /phrases
  # GET /phrases.json
  def index
    @phrases = Phrase.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @phrases }
    end
  end

  # GET /phrases/1
  # GET /phrases/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @phrase }
    end
  end

  # GET /phrases/new
  # GET /phrases/new.json
  def new
    @phrase = Phrase.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @phrase }
    end
  end

  # GET /phrases/1/edit
  def edit
  end

  # POST /phrases
  # POST /phrases.json
  def create
    @phrase = Phrase.new(phrase_params)

    respond_to do |format|
      if @phrase.save
        format.html { redirect_to @phrase, notice: 'Phrase was successfully created.' }
        format.json { render json: @phrase, status: :created, location: @phrase }
      else
        format.html { render action: "new" }
        format.json { render json: @phrase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phrases/1
  # PATCH/PUT /phrases/1.json
  def update
    respond_to do |format|
      if @phrase.update_attributes(phrase_params)
        format.html { redirect_to @phrase, notice: 'Phrase was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @phrase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phrases/1
  # DELETE /phrases/1.json
  def destroy
    @phrase.destroy

    respond_to do |format|
      format.html { redirect_to @phrase.sourcemod_plugin }
      format.json { head :no_content }
    end
  end


  def translate

    # @phrases = @sourcemod_plugin.phrases
    #           .joins(:translations)
    #           .where(["translations.language_id NOT IN (?)", current_user.languages.pluck(:id)])
    #           .order("LOWER(phrases.name) ASC")


    # #@phrases = @sourcemod_plugin.phrases.where()

    finished_lang_ids = @phrase.languages.collect{|o|o.id}

    @languages = current_user.languages.where(["id NOT IN (?)", finished_lang_ids]).order("LOWER(name) ASC")

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def translate_submit

    
    respond_to do |format|
      if @phrase.save
        format.html { redirect_to @phrase.sourcemod_plugin, notice: 'Phrase file uploaded!' }
      else
        format.html { render action: "translate" }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phrase
      @phrase = Phrase.find(params[:id])
    end

    # Use this method to whitelist the permissible parameters. Example: params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def phrase_params
      params.require(:phrase).permit(:sourcemod_plugin_id, :name, :format, :translations_count)
    end
end
