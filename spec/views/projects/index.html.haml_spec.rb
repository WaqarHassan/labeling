require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  before(:each) do
    assign(:projects, [
      Project.create!(
        :id => 2,
        :name => "Name",
        :description => "MyText",
        :created_by => 3,
        :updated_by => 4
      ),
      Project.create!(
        :id => 2,
        :name => "Name",
        :description => "MyText",
        :created_by => 3,
        :updated_by => 4
      )
    ])
  end

  it "renders a list of projects" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
