FactoryBot.define do
  factory :listing do
    title { "MyString" }
    description { "MyText" }
    price_cents { 1 }
    condition { 1 }
    status { 1 }
    user { nil }
    category { nil }
  end
end
