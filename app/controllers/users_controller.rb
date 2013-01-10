class UsersController < ApplicationController
  load_and_authorize_resource

  before_action :set_user, only: [:show]


  def index

  end


  def show

  end


  def leaders
#     SELECT users.*, COUNT(sourcemod_plugins."id") AS "plugin_count" FROM
# users
# LEFT JOIN sourcemod_plugins ON (users.id=sourcemod_plugins.user_id)
# GROUP BY users.id
# ORDER BY plugin_count DESC
# LIMIT 10
    @plugin_leaders = User.select("users.*, COUNT(sourcemod_plugins.\"id\") AS plugin_count")
                          .joins("LEFT JOIN sourcemod_plugins ON (users.id=sourcemod_plugins.user_id)")
                          .group("users.id")
                          .having("COUNT(sourcemod_plugins.\"id\") > 0")
                          .order("plugin_count DESC")
                          .limit(10)

    @translation_leaders = User.select("users.*, COUNT(translations.\"id\") AS translation_count")
                               .joins("LEFT JOIN translations ON (users.id=translations.user_id)")
                               .where(["translations.imported = ?", false])
                               .group("users.id")
                               .having("COUNT(translations.\"id\") > 0")
                               .order("translation_count DESC")
                               .limit(10)
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

end
