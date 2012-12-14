class Phrase < ActiveRecord::Base
  belongs_to    :sourcemod_plugin, counter_cache: true

  has_many      :translations,  dependent: :destroy
  has_many      :languages,  through: :translations

  validates_presence_of     :sourcemod_plugin_id
  validates_presence_of     :name

  validates_uniqueness_of   :name, scope: :sourcemod_plugin_id

  # Retrieves the first english translation of this phrase
  def english
    return nil unless self.translations
    self.translations.english.first
  end

  # Do we already have a translation in this language?
  def has_language?(lang)
    self.translations.where(:language => lang).exists?
  end

end
