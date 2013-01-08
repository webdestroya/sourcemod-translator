

desc "Clear out all tags that are not being used by any plugins"
task :clear_unused_tags => :environment do
  Tag.unused.destroy_all
end