class CreateTranslations < ActiveRecord::Migration
  def change
    create_table :translations do |t|
      t.integer :phrase_id,                 null: false
      t.integer :language_id,               null: false
      t.integer :user_id,                   null: false
      t.string  :text,                      null: false
      t.integer :votes_count,               null: false, default: 0
      t.integer :translation_flags_count,   null: false, default: 0

      t.timestamps
    end
  end
end
