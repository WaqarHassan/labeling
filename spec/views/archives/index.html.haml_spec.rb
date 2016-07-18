require 'rails_helper'

RSpec.describe "archives/index", type: :view do
  before(:each) do
    assign(:archives, [
      Archive.create!(
        :id => 2,
        :ecr_id => 3,
        :user_id => 4,
        :number_of_component => 5,
        :updated_by => "Updated By",
        :orignal_value => "Orignal Value"
      ),
      Archive.create!(
        :id => 2,
        :ecr_id => 3,
        :user_id => 4,
        :number_of_component => 5,
        :updated_by => "Updated By",
        :orignal_value => "Orignal Value"
      )
    ])
  end

  it "renders a list of archives" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => "Updated By".to_s, :count => 2
    assert_select "tr>td", :text => "Orignal Value".to_s, :count => 2
  end
end
