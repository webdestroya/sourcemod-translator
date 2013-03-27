namespace :stats do

task :plugins => :environment do
  SourcemodPlugin.where(:id=>29).each do |plugin|
    plugin.translations
      .web
      .select("to_char(translations.created_at, 'YYYY-MM-DD') as date, count(*) as trans_count")
      .group("to_char(translations.created_at, 'YYYY-MM-DD')")
      .each do |metric|
        puts "#{metric.date} => #{metric.trans_count}"
      end
  end
end

end