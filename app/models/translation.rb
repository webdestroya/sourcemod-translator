class Translation < ActiveRecord::Base
  #include ActiveModel::ForbiddenAttributesProtection

  # TODO: After saving this translation, we should update the percentages on the sourcemod plugin?

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

  scope :imported,  -> {where(imported: true)}
  scope :web,       -> {where(imported: false)}

  scope :english,   -> {where(:language_id => Language.find_by_iso_code("en").id)}

  scope :language,  ->(language) {where(language_id: language.id)}

end
