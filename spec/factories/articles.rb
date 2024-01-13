# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    title { Faker::Name.unique.name }
    body { Faker::Alphanumeric.alpha(number: 100) }
  end
end