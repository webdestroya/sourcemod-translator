require 'spec_helper'

describe SourcemodPlugin do
  #pending "add some examples to (or delete) #{__FILE__}"

  it "tests the importer" do
    sm = SourcemodPlugin.create! :user_id => 1,
                             :name => "Test Plugin",
                             :filename => "test"
    # blah
    testfile = File.open("test/fixtures/test.phrases.txt")

    sm.load_from_file(testfile)

    sm.save!

    sm.phrases.each do |phrase|
      #puts "PHRASE"
      #puts phrase.name
      #puts Digest::MD5.hexdigest(phrase.name)
      puts "Phrase: #{phrase.name}"
      trans = phrase.translations.english.first
      puts " => <<<#{trans.text}>>>"
      Digest::MD5.hexdigest(trans.text).should eql(phrase.name)

      #puts "\t=> #{phrase.translations.english.first.text}"
    end

  end


  it "tests the new importer" do
    sm = SourcemodPlugin.create! :user_id => 1,
                             :name => "Test Plugin",
                             :filename => "test"
    # blah
    testfile = File.open("test/fixtures/test.phrases.txt")
    sm.load_from_file(testfile)
    sm.save!

    sm = SourcemodPlugin.find(sm.id)

    puts "TRY 1========="
    display_plugin(sm)
    puts "/TRY 1========="

    sm = SourcemodPlugin.find(sm.id)

    testfile = File.open("test/fixtures/test2.phrases.txt")
    sm.load_from_file(testfile)
    sm.save!

    sm = SourcemodPlugin.find(sm.id)

    puts "TRY 2========="
    display_plugin(sm)
    puts "/TRY 2========="

  end

end


def display_plugin(sm)
  sm.phrases.each do |phrase|
    puts "Phrase: #{phrase.id}, #{phrase.name}"
    if phrase.format
      puts "\tFormat: #{phrase.format}"
      phrase.format_infos.each do |fmt|
        puts "\tFmt #{fmt.id},#{fmt.position}:#{fmt.format_class}:#{fmt.description}"
      end
    end
    phrase.translations.each do |trans|
      puts "\t#{trans.language.iso_code}: #{trans.text}"
    end
  end
end
