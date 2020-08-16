FactoryBot.define do
  factory :user do
    user_id { 1 }
    name { "MyString" }
    email { "MyString" }
    picture { "MyString" }
    comment { "MyText" }
    sex { "MyString" }
    country { "MyString" }
    admin { false }
  end
end
