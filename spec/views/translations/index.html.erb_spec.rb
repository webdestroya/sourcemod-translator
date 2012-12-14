require 'spec_helper'

describe "translations/index" do
  before(:each) do
    assign(:translations, [
      stub_model(Translation,
        :phrase_id => 1,
        :language_id => 1,
        :user_id => 1,
        :text => "Text",
        :votes_count => 1,
        :translation_flags_count => 1
      ),
      stub_model(Translation,
        :phrase_id => 1,
        :language_id => 1,
        :user_id => 1,
        :text => "Text",
        :votes_count => 1,
        :translation_flags_count => 1
      )
    ])
  end

  it "renders a list of translations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
