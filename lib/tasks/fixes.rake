
namespace :fix do

desc "Flags translations that have been imported"
task :flag_imports => :environment do
  SourcemodPlugin.all.each do |plugin|
    plugin.translations.where(user_id: plugin.user_id).each do |trans|
      trans.update_column(:imported, true)
    end
  end
end


end