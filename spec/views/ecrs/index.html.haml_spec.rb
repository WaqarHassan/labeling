require 'rails_helper'

RSpec.describe "ecrs/index", type: :view do
  before(:each) do
    assign(:ecrs, [
      Ecr.create!(
        :id => 2,
        :name => "Name",
        :user_id => 3,
        :status => "Status",
        :note => "MyText",
        :station_id => 4,
        :rework_of => 5
      ),
      Ecr.create!(
        :id => 2,
        :name => "Name",
        :user_id => 3,
        :status => "Status",
        :note => "MyText",
        :station_id => 4,
        :rework_of => 5
      )
    ])
  end

  it "renders a list of ecrs" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
