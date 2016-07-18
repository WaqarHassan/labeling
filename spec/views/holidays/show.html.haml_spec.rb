require 'rails_helper'

RSpec.describe "holidays/show", type: :view do
  before(:each) do
    @holiday = assign(:holiday, Holiday.create!(
      :id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
  end
end
