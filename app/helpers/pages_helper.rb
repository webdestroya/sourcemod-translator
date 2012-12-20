module PagesHelper

  def get_started_path
    if current_user
      sourcemod_plugins_path
    else
      "/auth/steam"
    end
  end

end
