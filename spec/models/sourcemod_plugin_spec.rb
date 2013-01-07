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

end
