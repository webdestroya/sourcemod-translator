require 'spec_helper'

describe "phrases/index" do
  before(:each) do
    assign(:phrases, [
      stub_model(Phrase,
        :sourcemod_plugin_id => 1,
        :name => "Name",
        :format => "Format",
        :translations_count => 1
      ),
      stub_model(Phrase,
        :sourcemod_plugin_id => 1,
        :name => "Name",
        :format => "Format",
        :translations_count => 1
      )
    ])
  end

  it "renders a list of phrases" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Format".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
