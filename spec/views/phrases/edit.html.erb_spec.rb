require 'spec_helper'

describe "phrases/edit" do
  before(:each) do
    @phrase = assign(:phrase, stub_model(Phrase,
      :sourcemod_plugin_id => 1,
      :name => "MyString",
      :format => "MyString",
      :translations_count => 1
    ))
  end

  it "renders the edit phrase form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => phrases_path(@phrase), :method => "post" do
      assert_select "input#phrase_sourcemod_plugin_id", :name => "phrase[sourcemod_plugin_id]"
      assert_select "input#phrase_name", :name => "phrase[name]"
      assert_select "input#phrase_format", :name => "phrase[format]"
      assert_select "input#phrase_translations_count", :name => "phrase[translations_count]"
    end
  end
end
