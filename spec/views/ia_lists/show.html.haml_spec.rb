require 'rails_helper'

RSpec.describe "ia_lists/show", type: :view do
  before(:each) do
    @ia_list = assign(:ia_list, IaList.create!(
      :name => "Name",
      :project_id => 2,
      :business_unit => "Business Unit",
      :comp_count => 3,
      :notes => "MyText",
      :is_active => false,
      :translation => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Business Unit/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
