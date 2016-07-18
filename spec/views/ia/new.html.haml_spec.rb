require 'rails_helper'

RSpec.describe "ia/new", type: :view do
  before(:each) do
    assign(:ium, Ium.new(
      :id => 1,
      :name => "MyString",
      :translation => false,
      :horw => false
    ))
  end

  it "renders new ium form" do
    render

    assert_select "form[action=?][method=?]", ia_path, "post" do

      assert_select "input#ium_id[name=?]", "ium[id]"

      assert_select "input#ium_name[name=?]", "ium[name]"

      assert_select "input#ium_translation[name=?]", "ium[translation]"

      assert_select "input#ium_horw[name=?]", "ium[horw]"
    end
  end
end
