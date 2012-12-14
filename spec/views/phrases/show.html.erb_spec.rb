require 'spec_helper'

describe "phrases/show" do
  before(:each) do
    @phrase = assign(:phrase, stub_model(Phrase,
      :sourcemod_plugin_id => 1,
      :name => "Name",
      :format => "Format",
      :translations_count => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Format/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
