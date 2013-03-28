
namespace :cron do

desc "Clear out all tags that are not being used by any plugins"
task :clear_unused_tags => :environment do
  Tag.unused.destroy_all
end


desc "Update SourceMod percentages (attempted, completed)"
task :percentages => :environment do
  SourcemodPlugin.has_phrases.each do |plugin|
    plugin.update_percentages
    plugin.update_column :web_translations_count, plugin.translations.web.count
  end
end


end