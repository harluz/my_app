# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "example#{n}@example.com" }
    picture { 'MyString' }
    comment { 'MyText' }
    sex { 'men' }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    admin { false }
  end
end
