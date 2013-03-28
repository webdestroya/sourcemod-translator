class AddWebTranslationsCountToSourcemodPlugins < ActiveRecord::Migration
  def change
    add_column :sourcemod_plugins, :web_translations_count, :integer
  end
end
