class CreatePluginStats < ActiveRecord::Migration
  def change
    create_table :plugin_stats do |t|
      t.integer :sourcemod_plugin_id, null: false
      t.text    :participation

      t.timestamps
    end

    add_index :plugin_stats, :sourcemod_plugin_id, unique: true

  end
end
