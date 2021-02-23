# frozen_string_literal: true

FactoryBot.define do
  factory :response, class: 'Response' do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    comment { 'response comment test' }
    created_at { 10.minutes.ago }

    association :user
    association :order

    trait :yesterday do
      image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
      created_at { 1.day.ago }
    end

    trait :day_before_yesterday do
      image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
      created_at { 2.days.ago }
    end

    trait :now do
      image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
      created_at { Time.zone.now }
    end
  end
end
