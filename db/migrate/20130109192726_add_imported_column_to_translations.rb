class AddImportedColumnToTranslations < ActiveRecord::Migration
  def change
    add_column :translations, :imported, :boolean, default: false

    add_index :translations, :imported
  end
end
