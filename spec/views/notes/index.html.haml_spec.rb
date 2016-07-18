require 'rails_helper'

RSpec.describe "notes/index", type: :view do
  before(:each) do
    assign(:notes, [
      Note.create!(
        :id => 2,
        :ecr_id => 3,
        :created_by => 4,
        :updated_by => 5,
        :description => "MyText"
      ),
      Note.create!(
        :id => 2,
        :ecr_id => 3,
        :created_by => 4,
        :updated_by => 5,
        :description => "MyText"
      )
    ])
  end

  it "renders a list of notes" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
