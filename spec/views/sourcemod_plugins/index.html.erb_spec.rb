require 'spec_helper'

describe "sourcemod_plugins/index" do
  before(:each) do
    assign(:sourcemod_plugins, [
      stub_model(SourcemodPlugin,
        :user_id => 1,
        :name => "Name",
        :filename => "Filename",
        :phrases_count => 1
      ),
      stub_model(SourcemodPlugin,
        :user_id => 1,
        :name => "Name",
        :filename => "Filename",
        :phrases_count => 1
      )
    ])
  end

  it "renders a list of sourcemod_plugins" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Filename".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
