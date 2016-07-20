require 'rails_helper'

RSpec.describe "rework_infos/index", type: :view do
  before(:each) do
    assign(:rework_infos, [
      ReworkInfo.create!(
        :collab_name => "Collab Name",
        :user_id => 2,
        :station_id => 3,
        :reason => "MyText",
        :comp_number => 4,
        :type => "Type",
        :ecr_id => 5
      ),
      ReworkInfo.create!(
        :collab_name => "Collab Name",
        :user_id => 2,
        :station_id => 3,
        :reason => "MyText",
        :comp_number => 4,
        :type => "Type",
        :ecr_id => 5
      )
    ])
  end

  it "renders a list of rework_infos" do
    render
    assert_select "tr>td", :text => "Collab Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end
