require 'rails_helper'

RSpec.describe "ecrs/edit", type: :view do
  before(:each) do
    @ecr = assign(:ecr, Ecr.create!(
      :id => 1,
      :name => "MyString",
      :user_id => 1,
      :status => "MyString",
      :note => "MyText",
      :station_id => 1,
      :rework_of => 1
    ))
  end

  it "renders the edit ecr form" do
    render

    assert_select "form[action=?][method=?]", ecr_path(@ecr), "post" do

      assert_select "input#ecr_id[name=?]", "ecr[id]"

      assert_select "input#ecr_name[name=?]", "ecr[name]"

      assert_select "input#ecr_user_id[name=?]", "ecr[user_id]"

      assert_select "input#ecr_status[name=?]", "ecr[status]"

      assert_select "textarea#ecr_note[name=?]", "ecr[note]"

      assert_select "input#ecr_station_id[name=?]", "ecr[station_id]"

      assert_select "input#ecr_rework_of[name=?]", "ecr[rework_of]"
    end
  end
end
