class CreatePhrases < ActiveRecord::Migration
  def change
    create_table :phrases do |t|
      t.integer :sourcemod_plugin_id,   null: false
      t.string  :name,                  null: false
      t.string  :format
      t.integer :translations_count,    null: false, default: 0

      t.timestamps
    end

    add_index :phrases, [:sourcemod_plugin_id, :name], unique: true

  end
end
