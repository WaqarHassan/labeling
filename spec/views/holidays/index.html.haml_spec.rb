require 'rails_helper'

RSpec.describe "holidays/index", type: :view do
  before(:each) do
    assign(:holidays, [
      Holiday.create!(
        :id => 2
      ),
      Holiday.create!(
        :id => 2
      )
    ])
  end

  it "renders a list of holidays" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
