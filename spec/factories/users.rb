FactoryBot.define do
  factory :user do
    name { "MyString" }
    email { "MyString" }
    picture { "MyString" }
    comment { "MyText" }
    sex { "MyString" }
    admin { false }
  end
end
