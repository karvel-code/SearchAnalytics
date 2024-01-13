FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { Faker::Alphanumeric.alpha(number: 6) }
  end
end