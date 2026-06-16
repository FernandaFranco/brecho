FactoryBot.define do
  factory :listing do
    title { "Vestido Zara tamanho M" }
    description { "Usado apenas uma vez, em otimo estado" }
    price_cents { 5990 }
    condition { :used }
    status { :active }
    user
    category
  end
end
