# frozen_string_literal: true

FactoryBot.define do
  factory :imdb_rating, aliases: [:rating] do
    average_rating { rand(10..100) * 10 }
    num_votes { rand(10..100_000) }
  end
end
