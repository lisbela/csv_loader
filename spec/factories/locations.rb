FactoryBot.define do
    factory :location do
      movie
      country
      name { Faker::Address.city }
    end
  end
  