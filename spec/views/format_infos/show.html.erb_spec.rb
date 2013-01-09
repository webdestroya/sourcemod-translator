require 'spec_helper'

describe "format_infos/show" do
  before(:each) do
    @format_info = assign(:format_info, stub_model(FormatInfo,
      :phrase_id => 1,
      :position => 1,
      :format_class => "Format Class",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Format Class/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
  end
end
