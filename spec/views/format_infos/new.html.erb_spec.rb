require 'spec_helper'

describe "format_infos/new" do
  before(:each) do
    assign(:format_info, stub_model(FormatInfo,
      :phrase_id => 1,
      :position => 1,
      :format_class => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new format_info form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => format_infos_path, :method => "post" do
      assert_select "input#format_info_phrase_id", :name => "format_info[phrase_id]"
      assert_select "input#format_info_position", :name => "format_info[position]"
      assert_select "input#format_info_format_class", :name => "format_info[format_class]"
      assert_select "input#format_info_description", :name => "format_info[description]"
    end
  end
end
