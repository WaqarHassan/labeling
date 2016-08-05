require 'rails_helper'

RSpec.describe "ia_lists/edit", type: :view do
  before(:each) do
    @ia_list = assign(:ia_list, IaList.create!(
      :name => "MyString",
      :project_id => 1,
      :business_unit => "MyString",
      :comp_count => 1,
      :notes => "MyText",
      :is_active => false,
      :translation => false
    ))
  end

  it "renders the edit ia_list form" do
    render

    assert_select "form[action=?][method=?]", ia_list_path(@ia_list), "post" do

      assert_select "input#ia_list_name[name=?]", "ia_list[name]"

      assert_select "input#ia_list_project_id[name=?]", "ia_list[project_id]"

      assert_select "input#ia_list_business_unit[name=?]", "ia_list[business_unit]"

      assert_select "input#ia_list_comp_count[name=?]", "ia_list[comp_count]"

      assert_select "textarea#ia_list_notes[name=?]", "ia_list[notes]"

      assert_select "input#ia_list_is_active[name=?]", "ia_list[is_active]"

      assert_select "input#ia_list_translation[name=?]", "ia_list[translation]"
    end
  end
end
