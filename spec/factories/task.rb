# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    name { FFaker::Lorem.sentence }
    project
    after(:create) do |task|
      create_list(:comment, 4, task: task)
    end
  end
end
