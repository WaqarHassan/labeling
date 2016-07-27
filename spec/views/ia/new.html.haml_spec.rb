require 'rails_helper'

RSpec.describe "ia/new", type: :view do
  before(:each) do
    assign(:ium, Ium.new(
      :name => "MyString",
      :translation => false,
      :horw => false,
      :project_id => 1
    ))
  end

  it "renders new ium form" do
    render

    assert_select "form[action=?][method=?]", ia_path, "post" do

      assert_select "input#ium_name[name=?]", "ium[name]"

      assert_select "input#ium_translation[name=?]", "ium[translation]"

      assert_select "input#ium_horw[name=?]", "ium[horw]"

      assert_select "input#ium_project_id[name=?]", "ium[project_id]"
    end
  end
end
