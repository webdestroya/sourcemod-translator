class CreateFormatInfos < ActiveRecord::Migration
  def change
    create_table :format_infos do |t|
      t.integer :phrase_id,       null: false
      t.integer :position,        null: false
      t.string  :format_class,    null: false, limit: 3
      t.string  :description

      t.timestamps
    end

    add_index :format_infos, [:phrase_id, :position], unique: true

  end
end
