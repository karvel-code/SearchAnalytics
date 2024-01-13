FactoryBot.define do
  factory :search do
    query { Faker::Name.unique.name }
    user { create(:user) }
  end
end