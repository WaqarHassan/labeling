require 'rails_helper'

RSpec.describe "ia/show", type: :view do
  before(:each) do
    @ium = assign(:ium, Ium.create!(
      :id => 2,
      :name => "Name",
      :translation => false,
      :horw => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
