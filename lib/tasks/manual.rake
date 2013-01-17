#encoding: utf-8
namespace :manual do

desc "Import phrases"
task :import_phrases, [:file, :plugin_id] => :environment do |t,args|
  puts "File: #{args[:file]}"

  ulfilename = args[:file]

  @sourcemod_plugin = SourcemodPlugin.find args[:plugin_id].to_i

  puts "Import phrases from #{ulfilename} for #{@sourcemod_plugin.name}"

  if ulfilename =~ /\.zip$/i

    zf = Zip::ZipFile.new(ulfilename)
    zf.each_with_index do |entry, index|
      entry_name = entry.name
      if entry_name =~ /#{@sourcemod_plugin.filename}\.phrases\.txt$/i
        puts "\tImporting #{entry_name}"
        #puts "entry #{index} is #{entry.name}, size = #{entry.size}, compressed size = #{entry.compressed_size}"
        begin
          count = @sourcemod_plugin.load_from_file zf.get_input_stream(entry)
          puts count
          #puts @sourcemod_plugin.phrases.inspect
        rescue Exception => e
          puts "\tERROR: #{entry_name} #{e.message}"
        end
      end
    end

  elsif ulfilename =~ /\.txt$/i
    @sourcemod_plugin.load_from_file File.open(ulfilename, "rb")
  end

  @sourcemod_plugin.save
  @sourcemod_plugin.update_percentages

end


end