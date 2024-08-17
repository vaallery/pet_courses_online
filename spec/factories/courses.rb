FactoryBot.define do
  factory :course do
    name { "My Course" }
    description { "My Course Description" }
    active { true }
    association :author
  end
end
