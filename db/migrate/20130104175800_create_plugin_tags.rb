class CreatePluginTags < ActiveRecord::Migration
  def change
    create_table :plugin_tags do |t|
      t.integer :sourcemod_plugin_id,   null: false
      t.integer :tag_id,                null: false
    end

    add_index :plugin_tags, [:tag_id, :sourcemod_plugin_id], unique: true

  end
end
