FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.free_email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { 'secure' }
  end
end
