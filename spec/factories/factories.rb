FactoryGirl.define do
  factory :game do |f|
    sequence(:name) {|n| "Game #{n}" }

    trait :just_started do
      phase Game::PHASES[:awaiting_players]
    end

    trait :ongoing do
      phase Game::PHASES[:movement]
    end

    factory :game_just_started, traits: [:just_started]
    factory :game_ongoing, traits: [:ongoing]
  end
end

FactoryGirl.define do
  factory :state do
    game

    factory :state_spring do
      season { "Spring" }
    end

    factory :state_fall do
      season { "Fall" }
    end
  end
end

FactoryGirl.define do
  factory :order_list do
    sequence(:power) {|n| "Power #{n}" }
    state
    orders { "" }
  end
end

FactoryGirl.define do
  factory :user do |f|
    sequence(:name) {|n| "User #{n}" }
    sequence(:email) {|n| "general#{n}@hq.com" }
  end
end

FactoryGirl.define do
  factory :power_assignment do |f|
    sequence(:power) {|n| "Power #{n}" }

    factory :power_assignment_with_user do
      user
    end
    
    factory :power_assignment_with_game do
      game
    end
    
    factory :power_assignment_with_both do
      user
      game
    end
  end
end
