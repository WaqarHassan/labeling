FactoryGirl.define do
  factory :admin_user, class: 'Admin::User' do
    first_name "MyString"
    last_name "MyString"
    email "MyString"
    password ""
  end
end
