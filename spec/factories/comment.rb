# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    commentary { FFaker::Lorem.sentence }
    task
  end
end
