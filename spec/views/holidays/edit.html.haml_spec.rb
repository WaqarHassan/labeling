require 'rails_helper'

RSpec.describe "holidays/edit", type: :view do
  before(:each) do
    @holiday = assign(:holiday, Holiday.create!(
      :id => 1
    ))
  end

  it "renders the edit holiday form" do
    render

    assert_select "form[action=?][method=?]", holiday_path(@holiday), "post" do

      assert_select "input#holiday_id[name=?]", "holiday[id]"
    end
  end
end
