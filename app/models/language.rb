class Language < ActiveRecord::Base

  has_many  :translations, dependent: :destroy
  
  has_many  :user_languages, dependent: :destroy
  has_many  :users, through: :user_languages

  has_many  :web_translations, :conditions => "imported = 'f'", :class_name => "Translation"

  validates_presence_of   :iso_code
  validates_uniqueness_of :iso_code

  validates_presence_of   :name

  scope :not_english,    lambda {where(["languages.iso_code <> ?", "en"])}

  def english?
    self.iso_code.eql?("en")
  end

  def leaders
    return @leaders if defined? @leaders

    @leaders = User.select("users.*, COUNT(translations.\"id\") AS translation_count")
                   .joins("LEFT JOIN translations ON (users.id=translations.user_id)")
                   .where(["translations.imported = ?", false])
                   .where(["translations.language_id = ?", self.id])
                   .group("users.id")
                   .having("COUNT(translations.\"id\") > 0")
                   .order("translation_count DESC")
                   .limit(3)
                   .to_a

    @leaders
  end

end
