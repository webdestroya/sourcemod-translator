namespace :stats do

desc "Update plugin statistics"
task :plugins => :environment do
  SourcemodPlugin.has_phrases.each do |plugin|
    #puts plugin.name
    plugin.stats.update_all
  end
end

end