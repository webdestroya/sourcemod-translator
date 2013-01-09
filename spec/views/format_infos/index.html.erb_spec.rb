require 'spec_helper'

describe "format_infos/index" do
  before(:each) do
    assign(:format_infos, [
      stub_model(FormatInfo,
        :phrase_id => 1,
        :position => 1,
        :format_class => "Format Class",
        :description => "Description"
      ),
      stub_model(FormatInfo,
        :phrase_id => 1,
        :position => 1,
        :format_class => "Format Class",
        :description => "Description"
      )
    ])
  end

  it "renders a list of format_infos" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Format Class".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
