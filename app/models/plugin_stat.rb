class PluginStat < ActiveRecord::Base

  belongs_to    :sourcemod_plugin

  attr_accessible :contributers, :participation, :sourcemod_plugin_id

  validates_presence_of   :sourcemod_plugin_id
  validates_uniqueness_of :sourcemod_plugin_id


  def self.get_statistic(plugin, type, raw=true)
    stat = PluginStat.where(:sourcemod_plugin_id => plugin.id).select([:id, type]).limit(1).first
    return nil if stat.nil?

    if raw
      stat[type]
    else
      # if they don't want the raw version, then return json
      JSON stat[type]
    end
  end

  def update_all
    self.update_participation
    self.update_contributers
  end

  # Get a list of the contributers and how many
  # and what languages they contribute
  def update_contributers
    contributers = []
    self.sourcemod_plugin.translations.web
    .select("translations.user_id, count(*) as trans_count")
    .group("translations.user_id")
    .order("trans_count DESC")
    .limit(10)
    .each do |contrib|
      entry = {
        user_id: contrib.user_id.to_i, 
        translations: contrib.trans_count.to_i,
        languages: []
      }

      # TODO: calculate how many translations from each language

      contributers << entry
    end
    self.update_attribute(:contributers, contributers.to_json)
    contributers
  end

  # Shows how many translations have been added via the website over the last 52 weeks
  def update_participation

    activity = {}
    start = 1.year.ago.beginning_of_week
    53.times do |i|
      disp = start.strftime("%G W%V")
      activity[disp] = start < self.sourcemod_plugin.created_at ? nil : 0
      start = start.next_week
    end

    self.sourcemod_plugin.translations.web
    .select("to_char(translations.created_at, 'YYYY \"W\"IW') as date, count(*) as trans_count")
    .group("date")
    .order("date ASC")
    .each do |metric|
      activity[metric.date] = metric.trans_count.to_i
    end

    particip = {
      activity: activity,
      all: activity.values,
      created: self.sourcemod_plugin.created_at,
      created_week: self.sourcemod_plugin.created_at.strftime("%G W%V"),
      max: activity.values.compact.sort.last,
    }
    particip[:created_index] = activity.keys.index( particip[:created_week] )

    self.update_attribute(:participation, particip.to_json)
    particip
  end

end
