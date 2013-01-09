class SourcemodPlugin < ActiveRecord::Base

  # TODO: Add percent complete to DB
  # TODO: Add percent attempted to DB

  # TODO: What if the parser parsed the whole file, THEN tried to do all the DB queries?

  belongs_to    :user

  has_many      :phrases,   dependent: :destroy
  has_many      :translations,  through: :phrases
  has_many      :languages,  through: :translations, :uniq => true

  has_many      :plugin_tags, dependent: :destroy
  has_many      :tags, through: :plugin_tags
  
  validates_presence_of   :user_id
  validates_presence_of   :name
  validates_presence_of   :filename

  validates_uniqueness_of :filename

  scope :no_phrases,    -> {where(phrases_count: 0)}
  scope :has_phrases,    -> {where("sourcemod_plugins.phrases_count > 0")}

  scope :tagged,        ->(tags) {
    where([
      "sourcemod_plugins.id IN (SELECT plugin_tags.sourcemod_plugin_id FROM plugin_tags WHERE plugin_tags.tag_id IN (?))", 
      Tag.tokens(tags).collect{|t|t.id}
    ])
  }

  def tag_list
    self.tags.collect{|t|t.name}.join(",")
  end

  def tag_list=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end

  def percent_completed
    @percent_completed ||= ((100.0*self.translations.count) / (self.phrases.count * Language.count)).round 2
  end

  # This is the percentage of attempted languages / completed languages
  # If there are NO translations for a language, we don't count that language 
  def attempted
    @attempted ||= ((100.0*self.translations.count) / (self.phrases.count * self.languages.count)).round 2
  end

 
  def load_from_file(input_stream)
    valid_lines = []

    input_stream.readlines.each do |line|
      line.strip!
      line.gsub!(/\/\*.+\*\//, '')

      next if line =~ /^\s*\/\/.+$/
      next if line =~ /^\s*$/

      valid_lines << line 
    end

    self.errors.add(:file, "is invalid format") unless valid_lines.shift.eql?("\"Phrases\"")
    self.errors.add(:file, "is invalid format") unless valid_lines.shift.eql?("{")
    self.errors.add(:file, "is invalid format") unless valid_lines.pop.eql?("}")


    # TODO: Need some error handling here

    phrase = nil
    in_phrase = false

    valid_lines.each do |line|
      
      if in_phrase
        # bail out
        next if line.eql?("{")

        if line.eql?("}")
          in_phrase = false
          self.phrases << phrase
          phrase = nil
          next
        end

        #match = line.match(/^\s*\"([a-z0-9]{2,3}|\#format)\"\s+\"(.+)\"\s*$/)
        match = line.match /^\s*"([_0-9a-z]{2,5}|\#format)"\s+"((?:[^"\\]|\\.)+)"/

        next if match.nil?

        key = match[1]
        value = match[2]

        if key.eql?("#format")
          phrase.format = value
        else
          lang = Language.where(iso_code: key.downcase).first_or_create(name: key.downcase)

          # Remove any existing translations in this language
          existing_trans = phrase.translations.where(language: lang).first
          if existing_trans
            # if theres an existing one, deal with it

            if existing_trans.user_id.eql?(self.user_id)
              # It already exists, but is owned by the current user. just update
              existing_trans.update_attribute(:text, value)
              existing_trans.update_attribute(:imported, true)

            elsif !existing_trans.text.eql?(value)
              # It was created by another user (and the text is different)
              # remove the existing one
              existing_trans.destroy

              # add it back
              phrase.translations << phrase.translations.new( user_id: self.user_id, 
                                                              language: lang, 
                                                              text: value,
                                                              imported: true)
            end
          else
            # No existing translation found
            phrase.translations << phrase.translations.new(user_id: self.user_id, language: lang, text: value, imported: true)
          end
        end
        
      else
        in_phrase = true
        phrase_match = line.match /\s*"((?:[^"\\]|\\.)+)"/

        #phrase_name = line.gsub(/"/,'')
        phrase_name = phrase_match[1]

        phrase = self.phrases.where(name: phrase_name).first_or_initialize
        
        #phrase.translations = []
      end
    end
  end

  # This will change the owner of this plugin, and convert all translations
  # that are owned by that user (and convert them to another user)
  def change_owner!(new_user)
    SourcemodPlugin.transaction do
      # update the translations
      self.translations.where(:user_id => self.user_id).all do |trans|
        trans.update_column(:user_id, new_user.id)
      end

      # update the plugin
      self.update_column(:user_id, new_user.id)

    end
  end


  # TODO: This will drop all phrases that do not have an english translation
  # We use english as the primary language
  def clean!
    Phrase.transaction do
      english_phrase_ids = self.translations.english.pluck(:phrase_id)
      Phrase.where(sourcemod_plugin_id: self.id)
            .where(["\"phrases\".\"id\" NOT IN (?)", english_phrase_ids])
            .destroy_all
    end
  end

end
