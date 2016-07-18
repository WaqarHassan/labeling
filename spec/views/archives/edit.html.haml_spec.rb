require 'rails_helper'

RSpec.describe "archives/edit", type: :view do
  before(:each) do
    @archive = assign(:archive, Archive.create!(
      :id => 1,
      :ecr_id => 1,
      :user_id => 1,
      :number_of_component => 1,
      :updated_by => "MyString",
      :orignal_value => "MyString"
    ))
  end

  it "renders the edit archive form" do
    render

    assert_select "form[action=?][method=?]", archive_path(@archive), "post" do

      assert_select "input#archive_id[name=?]", "archive[id]"

      assert_select "input#archive_ecr_id[name=?]", "archive[ecr_id]"

      assert_select "input#archive_user_id[name=?]", "archive[user_id]"

      assert_select "input#archive_number_of_component[name=?]", "archive[number_of_component]"

      assert_select "input#archive_updated_by[name=?]", "archive[updated_by]"

      assert_select "input#archive_orignal_value[name=?]", "archive[orignal_value]"
    end
  end
end
