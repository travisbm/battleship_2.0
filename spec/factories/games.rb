FactoryGirl.define do
  factory :game do

    trait :game_over do
      shots 0
      score 10900
    end

  end
end
