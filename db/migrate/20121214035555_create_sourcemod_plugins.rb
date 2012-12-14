class CreateSourcemodPlugins < ActiveRecord::Migration
  def change
    create_table :sourcemod_plugins do |t|
      t.integer :user_id,         null: false
      t.string  :name,            null: false
      t.string  :filename,        null: false
      t.integer :phrases_count,   null: false, default: 0

      t.timestamps
    end

    add_index :sourcemod_plugins, :user_id

  end
end
