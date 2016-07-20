require 'rails_helper'

RSpec.describe "rework_infos/show", type: :view do
  before(:each) do
    @rework_info = assign(:rework_info, ReworkInfo.create!(
      :collab_name => "Collab Name",
      :user_id => 2,
      :station_id => 3,
      :reason => "MyText",
      :comp_number => 4,
      :type => "Type",
      :ecr_id => 5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Collab Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/5/)
  end
end
