# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "todolist#{i}@rg.ua" }
    password { FFaker::Internet.password }
    name { FFaker::Name.first_name }
    nickname { FFaker::Internet.user_name }
  end
end
