# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:name) { |i| "New Project_#{i}" }
    user
  end
end
