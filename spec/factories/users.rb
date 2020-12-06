# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "example#{n}@example.com" }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }

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
