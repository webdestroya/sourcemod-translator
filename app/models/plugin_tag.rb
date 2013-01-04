class PluginTag < ActiveRecord::Base

  belongs_to    :sourcemod_plugin
  belongs_to    :tag

  #validates_presence_of   :sourcemod_plugin_id
  #validates_presence_of   :tag_id

  validates_uniqueness_of :tag_id, scope: :sourcemod_plugin_id

end
