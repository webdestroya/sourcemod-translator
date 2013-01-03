class Language < ActiveRecord::Base

  has_many  :translations, dependent: :destroy
  
  has_many  :user_languages, dependent: :destroy
  has_many  :users, through: :user_languages


  validates_presence_of   :iso_code
  validates_uniqueness_of :iso_code

  validates_presence_of   :name

  def english?
    self.iso_code.eql?("en")
  end
end
