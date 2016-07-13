FactoryGirl.define do
  factory :cell do

    trait :boat do
      status "boat"
    end

    trait :vessel do
      status "vessel"
    end

    trait :carrier do
      status "carrier"
    end

    trait :invalid do
      status "catamaran"
    end

  end
end
