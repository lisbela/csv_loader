FactoryBot.define do
    factory :movie do
      title { Faker::Movie.title }
      description { Faker::Lorem.paragraph }
      year { Faker::Number.between(from: 1900, to: 2023) }
      director { Faker::Name.name }
    end
  end
  