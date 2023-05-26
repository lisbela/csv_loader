FactoryBot.define do
    factory :review do
      movie
      user
      comments { Faker::Lorem.paragraph }
      rating { Faker::Number.between(from: 1, to: 5) }
      movie_name { Faker::Movie.title }
    end
  end  