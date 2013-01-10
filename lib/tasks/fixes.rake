
namespace :fix do

desc "Flags translations that have been imported"
task :flag_imports => :environment do
  SourcemodPlugin.all.each do |plugin|
    plugin.translations.where(user_id: plugin.user_id).each do |trans|
      trans.update_column(:imported, true)
    end
  end
end



desc "Fix existing formats"
task :formats => :environment do
  Phrase.where("phrases.format IS NOT NULL").where("phrases.id NOT IN (SELECT format_infos.phrase_id FROM format_infos)").each do |phrase|
    phrase.generate_format_info({})
    phrase.save
  end
end


end