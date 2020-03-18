FactoryBot.define do
  factory :post do
    association :user
    title { Faker::Lorem.unique.sentence }
    description { Faker::Lorem.paragraph_by_chars(number: 1000) }
  end
end
