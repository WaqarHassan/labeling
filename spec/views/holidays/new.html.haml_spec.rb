require 'rails_helper'

RSpec.describe "holidays/new", type: :view do
  before(:each) do
    assign(:holiday, Holiday.new(
      :id => 1
    ))
  end

  it "renders new holiday form" do
    render

    assert_select "form[action=?][method=?]", holidays_path, "post" do

      assert_select "input#holiday_id[name=?]", "holiday[id]"
    end
  end
end
