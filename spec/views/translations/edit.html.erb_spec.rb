require 'spec_helper'

describe "translations/edit" do
  before(:each) do
    @translation = assign(:translation, stub_model(Translation,
      :phrase_id => 1,
      :language_id => 1,
      :user_id => 1,
      :text => "MyString",
      :votes_count => 1,
      :translation_flags_count => 1
    ))
  end

  it "renders the edit translation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => translations_path(@translation), :method => "post" do
      assert_select "input#translation_phrase_id", :name => "translation[phrase_id]"
      assert_select "input#translation_language_id", :name => "translation[language_id]"
      assert_select "input#translation_user_id", :name => "translation[user_id]"
      assert_select "input#translation_text", :name => "translation[text]"
      assert_select "input#translation_votes_count", :name => "translation[votes_count]"
      assert_select "input#translation_translation_flags_count", :name => "translation[translation_flags_count]"
    end
  end
end
