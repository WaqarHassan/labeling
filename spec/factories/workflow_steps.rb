FactoryGirl.define do
  factory :workflow_step do
    step_id 1
    object_type "MyString"
    actual_confirmation "2016-08-05 12:30:28"
    eta "2016-08-05 12:30:28"
    is_active false
    project_id 1
  end
end
