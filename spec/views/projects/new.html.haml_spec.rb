require 'rails_helper'

RSpec.describe "projects/new", type: :view do
  before(:each) do
    assign(:project, Project.new(
      :id => 1,
      :name => "MyString",
      :description => "MyText",
      :created_by => 1,
      :updated_by => 1
    ))
  end

  it "renders new project form" do
    render

    assert_select "form[action=?][method=?]", projects_path, "post" do

      assert_select "input#project_id[name=?]", "project[id]"

      assert_select "input#project_name[name=?]", "project[name]"

      assert_select "textarea#project_description[name=?]", "project[description]"

      assert_select "input#project_created_by[name=?]", "project[created_by]"

      assert_select "input#project_updated_by[name=?]", "project[updated_by]"
    end
  end
end
