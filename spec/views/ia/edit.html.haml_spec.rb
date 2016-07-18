require 'rails_helper'

RSpec.describe "ia/edit", type: :view do
  before(:each) do
    @ium = assign(:ium, Ium.create!(
      :id => 1,
      :name => "MyString",
      :translation => false,
      :horw => false
    ))
  end

  it "renders the edit ium form" do
    render

    assert_select "form[action=?][method=?]", ium_path(@ium), "post" do

      assert_select "input#ium_id[name=?]", "ium[id]"

      assert_select "input#ium_name[name=?]", "ium[name]"

      assert_select "input#ium_translation[name=?]", "ium[translation]"

      assert_select "input#ium_horw[name=?]", "ium[horw]"
    end
  end
end
