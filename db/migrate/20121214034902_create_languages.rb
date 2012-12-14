class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string    :iso_code,  null: false, limit: 2
      t.string    :name,      null: false
    end

    add_index :languages, :iso_code, unique: true
  end
end
