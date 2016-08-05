require 'rails_helper'

RSpec.describe "ia_lists/index", type: :view do
  before(:each) do
    assign(:ia_lists, [
      IaList.create!(
        :name => "Name",
        :project_id => 2,
        :business_unit => "Business Unit",
        :comp_count => 3,
        :notes => "MyText",
        :is_active => false,
        :translation => false
      ),
      IaList.create!(
        :name => "Name",
        :project_id => 2,
        :business_unit => "Business Unit",
        :comp_count => 3,
        :notes => "MyText",
        :is_active => false,
        :translation => false
      )
    ])
  end

  it "renders a list of ia_lists" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Business Unit".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
