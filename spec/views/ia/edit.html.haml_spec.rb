require 'rails_helper'

RSpec.describe "ia/edit", type: :view do
  before(:each) do
    @ium = assign(:ium, Ium.create!(
      :name => "MyString",
      :translation => false,
      :horw => false,
      :project_id => 1
    ))
  end

  it "renders the edit ium form" do
    render

    assert_select "form[action=?][method=?]", ium_path(@ium), "post" do

      assert_select "input#ium_name[name=?]", "ium[name]"

      assert_select "input#ium_translation[name=?]", "ium[translation]"

      assert_select "input#ium_horw[name=?]", "ium[horw]"

      assert_select "input#ium_project_id[name=?]", "ium[project_id]"
    end
  end
end
