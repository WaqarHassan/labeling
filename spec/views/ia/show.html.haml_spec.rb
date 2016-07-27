require 'rails_helper'

RSpec.describe "ia/show", type: :view do
  before(:each) do
    @ium = assign(:ium, Ium.create!(
      :name => "Name",
      :translation => false,
      :horw => false,
      :project_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/2/)
  end
end
