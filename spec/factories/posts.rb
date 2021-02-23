# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    english { 'post test' }
    japanese { 'ポストテストデータ' }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
    comment { 'post comment test' }
    created_at { 10.minutes.ago }

    association :user

    trait :yesterday do
      english { 'yesterday' }
      japanese { '昨日' }
      image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
      created_at { 1.day.ago }
    end

    trait :day_before_yesterday do
      english { 'day before yesterday' }
      japanese { '一昨日' }
      image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
      created_at { 2.days.ago }
    end

    trait :now do
      english { 'now' }
      japanese { '今' }
      image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
      created_at { Time.zone.now }
    end
  end
end
