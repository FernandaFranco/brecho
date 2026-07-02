FactoryBot.define do
  factory :user do
    email_address { "fer@brecho.com" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
