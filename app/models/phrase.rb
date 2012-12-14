class Phrase < ActiveRecord::Base
  belongs_to    :sourcemod_plugin, counter_cache: true

  has_many      :translations,  dependent: :destroy
  has_many      :languages,  through: :translations

end
