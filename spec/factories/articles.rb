# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article do
    category
    title { Faker::Lorem.words}
    content { Faker::Lorem.paragraph }
  end
end
