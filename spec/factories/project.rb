# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence(:name) { |i| "New Project_#{i}" }
    user
    after(:create) do |project|
      create_list(:task, 4, project: project)
    end
  end
end
