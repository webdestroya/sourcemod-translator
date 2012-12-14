require 'spec_helper'

describe "sourcemod_plugins/show" do
  before(:each) do
    @sourcemod_plugin = assign(:sourcemod_plugin, stub_model(SourcemodPlugin,
      :user_id => 1,
      :name => "Name",
      :filename => "Filename",
      :phrases_count => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Filename/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
