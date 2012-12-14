require 'spec_helper'

describe "sourcemod_plugins/new" do
  before(:each) do
    assign(:sourcemod_plugin, stub_model(SourcemodPlugin,
      :user_id => 1,
      :name => "MyString",
      :filename => "MyString",
      :phrases_count => 1
    ).as_new_record)
  end

  it "renders new sourcemod_plugin form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sourcemod_plugins_path, :method => "post" do
      assert_select "input#sourcemod_plugin_user_id", :name => "sourcemod_plugin[user_id]"
      assert_select "input#sourcemod_plugin_name", :name => "sourcemod_plugin[name]"
      assert_select "input#sourcemod_plugin_filename", :name => "sourcemod_plugin[filename]"
      assert_select "input#sourcemod_plugin_phrases_count", :name => "sourcemod_plugin[phrases_count]"
    end
  end
end
