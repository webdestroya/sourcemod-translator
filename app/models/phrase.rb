class Phrase < ActiveRecord::Base
  belongs_to    :sourcemod_plugin, counter_cache: true

  has_many      :translations,  dependent: :destroy
  has_many      :languages,  through: :translations, :uniq => true

  has_many      :format_infos,  dependent: :destroy, order: "format_infos.position ASC"

  validates_presence_of     :sourcemod_plugin_id
  validates_presence_of     :name

  validates_uniqueness_of   :name, scope: :sourcemod_plugin_id

  scope :plugin,  ->(plugin) {where(sourcemod_plugin_id: plugin.id)}

  scope :needs_translation,  ->(languages) {
    lang_ids = languages.collect{|l| l.id}
    where([
      "? <> (SELECT COUNT(DISTINCT translations.language_id) FROM translations WHERE translations.phrase_id = phrases.id AND translations.language_id IN (?))", 
      lang_ids.size, 
      lang_ids
    ])
  }

  # Retrieves the first english translation of this phrase
  def english
    return nil unless self.translations
    self.translations.english.first
  end

  # Do we already have a translation in this language?
  def has_language?(lang)

    lang = Language.find_by_iso_code(lang) if lang.is_a?(String)

    self.translations.where(:language => lang).exists?
  end

  def generate_format_info(list)
    return if self.format.nil?

    formats = self.format.split ','

    # ^({[0-9]+:[dixfsct]},?\s*)+$

    # iterate the format pairs
    formats.each do |fmt|
      match = fmt.strip.match /^{([0-9]+):([A-Za-z])}$/
      if match
        pos = match[1].to_i
        fmt_class = match[2]
        desc = list[match[1]]

        if self.new_record?
          self.format_infos.new position: pos, format_class: fmt_class, description: desc
        else
          new_fmt = self.format_infos.where(position: pos).first_or_initialize

          new_fmt.format_class = fmt_class
          new_fmt.description = desc
          new_fmt.save if new_fmt.changed?
        end
      end
    end

    # If this is an existing record, we should clear out all the formats that shouldnt exist
    unless self.new_record?
      self.format_infos.where(["format_infos.position > ?", formats.size]).destroy_all
    end

  end

end
