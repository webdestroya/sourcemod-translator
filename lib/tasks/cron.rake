

desc "Clear out all tags that are not being used by any plugins"
task :clear_unused_tags => :environment do
  Tag.where("tags.id NOT IN (SELECT plugin_tags.tag_id FROM plugin_tags)").destroy_all
end