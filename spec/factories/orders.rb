# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    english { 'test' }
    japanese { 'テストデータ' }
    comment { 'order comment test' }
    created_at { 10.minutes.ago }

    association :user

    trait :yesterday do
      english { 'yesterday' }
      japanese { '昨日' }
      created_at { 1.day.ago }
    end

    trait :day_before_yesterday do
      english { 'day before yesterday' }
      japanese { '一昨日' }
      created_at { 2.days.ago }
    end

    trait :now do
      english { 'now' }
      japanese { '今' }
      created_at { Time.zone.now }
    end
  end
end
