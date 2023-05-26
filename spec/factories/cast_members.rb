FactoryBot.define do
  factory :cast_member do
    movie
    name { Faker::Name.name }
  end
end
