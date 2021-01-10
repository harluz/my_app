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

    activated { true }
    activated_at { Time.zone.now }
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

    activated { true }
    activated_at { Time.zone.now }
  end

  factory :other_user, class: User do
    name { Faker::Name.name }
    sequence(:email) { |n| "example_other#{n}@example.com" }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    activated true
    activated_at { Time.zone.now }
  end

  factory :invalid_user, class: User do
    name { Faker::Name.name }
    sequence(:email) { |n| "example#{n}@example.com" }
    # image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    password { 'foobar' }
    password_confirmation { 'foobaz' }
    activated false
    activated_at { Time.zone.now }
  end

  factory :show_nil_user, class: User do
    id { '900' }
    name { nil }
    sequence(:email) { nil }
    # image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    password { nil }
    password_confirmation { nil }
    activated false
    activated_at { Time.zone.now }
  end
end
