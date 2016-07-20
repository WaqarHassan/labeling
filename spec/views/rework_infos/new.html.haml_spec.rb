require 'rails_helper'

RSpec.describe "rework_infos/new", type: :view do
  before(:each) do
    assign(:rework_info, ReworkInfo.new(
      :collab_name => "MyString",
      :user_id => 1,
      :station_id => 1,
      :reason => "MyText",
      :comp_number => 1,
      :type => "",
      :ecr_id => 1
    ))
  end

  it "renders new rework_info form" do
    render

    assert_select "form[action=?][method=?]", rework_infos_path, "post" do

      assert_select "input#rework_info_collab_name[name=?]", "rework_info[collab_name]"

      assert_select "input#rework_info_user_id[name=?]", "rework_info[user_id]"

      assert_select "input#rework_info_station_id[name=?]", "rework_info[station_id]"

      assert_select "textarea#rework_info_reason[name=?]", "rework_info[reason]"

      assert_select "input#rework_info_comp_number[name=?]", "rework_info[comp_number]"

      assert_select "input#rework_info_type[name=?]", "rework_info[type]"

      assert_select "input#rework_info_ecr_id[name=?]", "rework_info[ecr_id]"
    end
  end
end
