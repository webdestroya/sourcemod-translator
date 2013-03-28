class AddContributersPluginStats < ActiveRecord::Migration
  def change
    add_column :plugin_stats, :contributers, :text
  end
end
