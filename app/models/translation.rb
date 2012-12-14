class Translation < ActiveRecord::Base
  belongs_to  :language
  belongs_to  :phrase
  belongs_to  :user

  scope :english,   -> {where(:language_id => Language.find_by_iso_code("en").id)}

end
