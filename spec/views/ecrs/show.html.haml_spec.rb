require 'rails_helper'

RSpec.describe "ecrs/show", type: :view do
  before(:each) do
    @ecr = assign(:ecr, Ecr.create!(
      :id => 2,
      :name => "Name",
      :user_id => 3,
      :status => "Status",
      :note => "MyText",
      :station_id => 4,
      :rework_of => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
  end
end
