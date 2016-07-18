require 'rails_helper'

RSpec.describe "stations/new", type: :view do
  before(:each) do
    assign(:station, Station.new(
      :id => 1,
      :name => "MyString"
    ))
  end

  it "renders new station form" do
    render

    assert_select "form[action=?][method=?]", stations_path, "post" do

      assert_select "input#station_id[name=?]", "station[id]"

      assert_select "input#station_name[name=?]", "station[name]"
    end
  end
end
