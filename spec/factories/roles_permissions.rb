FactoryBot.define do
  factory :roles_permission do
    constraints { "MyString" }
    association :role
    association :permission
  end
end
