#require 'zip/zip'
task :ziptest => :environment do
  zf = Zip::ZipFile.new("test/fixtures/sourcemod-1.4.6-mac.zip")

  plugin_filename = "basebans"

  zf.each_with_index do |entry, index|
    
    entry_name = entry.name
    if entry_name =~ /#{plugin_filename}\.phrases\.txt$/

      puts "entry #{index} is #{entry.name}, size = #{entry.size}, compressed size = #{entry.compressed_size}"
      data = zf.get_input_stream(entry)
      puts data.readlines.join("")
    end
    # use zf.get_input_stream(entry) to get a ZipInputStream for the entry
    # entry can be the ZipEntry object or any object which has a to_s method that
    # returns the name of the entry.
  end
end