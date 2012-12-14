class SourcemodPlugin < ActiveRecord::Base

  belongs_to    :user

  has_many      :phrases,   dependent: :destroy
  has_many      :translations,  through: :phrases
  has_many      :languages,  through: :translations, :uniq => true
  
  validates_presence_of   :user_id
  validates_presence_of   :name
  validates_presence_of   :filename

  scope :has_phrases,    -> {where(phrases_count: 0)}

 
  def load_from_file(tmpfile)
    valid_lines = []

    File.open(tmpfile).readlines.each do |line|
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

        match = line.match(/^\s*\"([a-z0-9]{2,3}|\#format)\"\s+\"(.+)\"\s*$/)

        next if match.nil?

        key = match[1]
        value = match[2]

        if key.eql?("#format")
          phrase.format = value
        else
          lang = Language.where(iso_code: key.downcase).first_or_create(name: key.downcase)

          # LATER: If this is the plugin owner, then just overwrite the translation
          # Skip over anything that is already existing
          unless phrase.translations.where(language: lang).exists?
            translation = phrase.translations.new
            translation.user_id = self.user_id
            translation.language = lang
            translation.text = value
            phrase.translations << translation
          end
        end
        
      else
        in_phrase = true
        phrase_name = line.gsub(/"/,'')

        phrase = self.phrases.where(:name => phrase_name).first_or_initialize
        
        #phrase.translations = []
      end
    end



  end

end
