# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stop do
    shuttle
    name {Faker::Address.street_address}
  end
end
