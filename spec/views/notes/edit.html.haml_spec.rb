require 'rails_helper'

RSpec.describe "notes/edit", type: :view do
  before(:each) do
    @note = assign(:note, Note.create!(
      :id => 1,
      :ecr_id => 1,
      :created_by => 1,
      :updated_by => 1,
      :description => "MyText"
    ))
  end

  it "renders the edit note form" do
    render

    assert_select "form[action=?][method=?]", note_path(@note), "post" do

      assert_select "input#note_id[name=?]", "note[id]"

      assert_select "input#note_ecr_id[name=?]", "note[ecr_id]"

      assert_select "input#note_created_by[name=?]", "note[created_by]"

      assert_select "input#note_updated_by[name=?]", "note[updated_by]"

      assert_select "textarea#note_description[name=?]", "note[description]"
    end
  end
end
