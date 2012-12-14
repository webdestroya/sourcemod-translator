class TranslationsController < ApplicationController
  before_filter :new_translation, :only => [:create]

  load_and_authorize_resource

  before_action :set_translation, only: [:show, :edit, :update, :destroy]

  # GET /translations
  # GET /translations.json
  def index
    @translations = Translation.all

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

    finished_lang_ids = @phrase.languages.pluck(:id)

    @languages = current_user.languages.where(["languages.id NOT IN (?)", finished_lang_ids]).order("LOWER(name) ASC")


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

    respond_to do |format|
      if @translation.save
        format.html { redirect_to @translation.phrase, notice: 'Translation was successfully created.' }
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
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @translation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /translations/1
  # DELETE /translations/1.json
  def destroy
    @translation.destroy

    respond_to do |format|
      format.html { redirect_to translations_url }
      format.json { head :no_content }
    end
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
