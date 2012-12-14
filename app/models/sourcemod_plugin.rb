class SourcemodPlugin < ActiveRecord::Base

  belongs_to    :user

  has_many      :phrases,   dependent: :destroy
  has_many      :translations,  through: :phrases
  #has_many      :translations,  through: :phrases

 
  def load_from_file(tmpfile)
    valid_lines = []

    File.open(tmpfile).readlines.each do |line|
      next if line =~ /^\s*\/\/.+$/
      next if line =~ /^\s*$/
      valid_lines << line 
    end

    self.errors.add(:file, "is invalid format") unless valid_lines.shift.strip.eql?("\"Phrases\"")
    self.errors.add(:file, "is invalid format") unless valid_lines.shift.strip.eql?("{")
    self.errors.add(:file, "is invalid format") unless valid_lines.pop.strip.eql?("}")


    phrase = nil
    in_phrase = false

    valid_lines.each do |line|
      line.strip!


      if in_phrase
        # bail out
        next if line.eql?("{")

        if line.eql?("}")
          in_phrase = false
          self.phrases << phrase
          phrase = nil
          next
        end

        match = line.match(/^\s*\"([a-z]{2}|\#format)\"\s+\"(.+)\"\s*$/)

        next if match.nil?

        key = match[1]
        value = match[2]

        if key.eql?("#format")
          phrase.format = value
        else
          translation = phrase.translations.new
          translation.user_id = self.user_id
          translation.language = Language.where(iso_code: key).first_or_create(name: key)
          translation.text = value
          phrase.translations << translation
        end
        
      else
        in_phrase = true
        phrase = self.phrases.new
        phrase.name = line.gsub(/"/,'')
        #phrase.translations = []
      end
    end



  end

end
