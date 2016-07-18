require 'rails_helper'

RSpec.describe "ia/index", type: :view do
  before(:each) do
    assign(:ia, [
      Ium.create!(
        :id => 2,
        :name => "Name",
        :translation => false,
        :horw => false
      ),
      Ium.create!(
        :id => 2,
        :name => "Name",
        :translation => false,
        :horw => false
      )
    ])
  end

  it "renders a list of ia" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
