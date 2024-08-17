FactoryBot.define do
  factory :author do
    name { Faker::Name.name }
    description { "Author" }
    active { true }
  end
end
