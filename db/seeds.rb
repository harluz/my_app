# frozen_string_literal: true

User.create!(name:  "Example User",
  email: "example@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(name:  name,
    email: email,
    password:              password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end

# ユーザーの一部を対象にポストを生成する
users = User.order(:created_at).take(6)
30.times do
  english = Faker::Creature::Animal.name[0..50]
  users.each { |user| user.posts.create!(english: english, japanese: '動物',
                                         image: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test2.jpg'))) }
end
# ユーザーの一部を対象にオーダーを生成する
# 30.times do
#   english = Faker::Creature::Animal.name[0..50]
#   users.each { |user| user.orders.create!(english: 'animal', japanese: '動物') }
# end
# ユーザーの一部を対象にレスポンスを生成する
