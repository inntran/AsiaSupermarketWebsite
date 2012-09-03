# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shuttle do
    name {Faker::Address.city}
    first_dayofweek "Friday"
    first_timeofday "5:20PM"
    second_dayofweek ""
    second_timeofday ""
    capacity 20
  end
end
