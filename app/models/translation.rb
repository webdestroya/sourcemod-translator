class Translation < ActiveRecord::Base
  belongs_to  :language
  belongs_to  :phrase, counter_cache: true
  belongs_to  :user

  validates_presence_of     :user_id
  #validates_associated      :user

  #validates_presence_of     :phrase_id
  #validates_associated      :phrase

  validates_presence_of     :language_id
  #validates_associated      :language

  validates_presence_of     :text

  scope :english,   -> {where(:language_id => Language.find_by_iso_code("en").id)}



end
