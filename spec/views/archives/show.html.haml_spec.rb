require 'rails_helper'

RSpec.describe "archives/show", type: :view do
  before(:each) do
    @archive = assign(:archive, Archive.create!(
      :id => 2,
      :ecr_id => 3,
      :user_id => 4,
      :number_of_component => 5,
      :updated_by => "Updated By",
      :orignal_value => "Orignal Value"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/Updated By/)
    expect(rendered).to match(/Orignal Value/)
  end
end
