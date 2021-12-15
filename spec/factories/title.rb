# frozen_string_literal: true

FactoryBot.define do
  factory :title do
    sequence(:name) { |n| "Test movie #{n}" }
  end
end
