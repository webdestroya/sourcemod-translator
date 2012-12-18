class UpdateLanguageLimit < ActiveRecord::Migration
  def change
    change_column :languages, :iso_code, :string, :limit => 5
  end
end
