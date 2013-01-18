class AddPhraseIndexToTranslations < ActiveRecord::Migration
  def change
    add_index :translations, :phrase_id

  end
end
