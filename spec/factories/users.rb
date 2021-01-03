# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "example#{n}@example.com" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }

    password { 'foobar' }
    password_confirmation { 'foobar' }

    trait :admin do
      admin { true }
    end
  end

  factory :user_update_after, class: User do
    name { Faker::Name.name }
    sequence(:email) { 'update_after_example@example.com' }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }

    password { 'foobar' }
    password_confirmation { 'foobar' }

    trait :admin do
      admin { true }
    end
  end

  factory :other_user, class: User do
    name { Faker::Name.name }
    sequence(:email) { |n| "example_other#{n}@example.com" }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end

  factory :invalid_user, class: User do
    name { Faker::Name.name }
    sequence(:email) { |n| "example#{n}@example.com" }
    # image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    password { 'foobar' }
    password_confirmation { 'foobaz' }
  end
end
