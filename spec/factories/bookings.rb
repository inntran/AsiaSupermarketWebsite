# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :booking do
    stop
    shuttle { stop.shuttle }
    customer { Faker::Name.name }
    phone_number { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.safe_email }
    shuttle_sequence 1
  end
end
