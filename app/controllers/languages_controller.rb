class LanguagesController < ApplicationController

  load_and_authorize_resource

  def index
    @languages = Language.where("iso_code <> 'en'").order("LOWER(name) ASC")



  end

  def add
    @language = Language.find(params[:language_id])
    @user_lang = current_user.user_languages.new(language_id: params[:language_id])
    
    respond_to do |format|
      if @user_lang.save
        format.html { redirect_to languages_path, notice: "We have added #{@language.name} to your list" }
      else
        format.html { redirect_to languages_path, notice: "PROBLEM" }
      end
    end

  end

  def remove
    @language = Language.find(params[:language_id])
    @userlang = UserLanguage.where(:user_id => current_user.id, :language_id => params[:language_id]).first

    respond_to do |format|
      if @userlang.destroy
        format.html { redirect_to languages_path, notice: "We have removed #{@language.name} from your list" }
      else
        format.html { redirect_to languages_path, notice: "PROBLEM" }
      end
    end
  end

end
