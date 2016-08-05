FactoryGirl.define do
  factory :ia_list do
    name "MyString"
    project_id 1
    business_unit "MyString"
    comp_count 1
    notes "MyText"
    is_active false
    requested_date "2016-08-05 12:51:11"
    to_be_approved_by "2016-08-05 12:51:11"
    translation false
  end
end
