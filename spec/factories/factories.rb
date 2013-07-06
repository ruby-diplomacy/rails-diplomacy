FactoryGirl.define do
  factory :game do |f|
    sequence(:name) {|n| "Game #{n}" }
  end
end

FactoryGirl.define do
  factory :state do
    game
  end
end

FactoryGirl.define do
  factory :order_list do
    sequence(:power) {|n| "Power #{n}" }
    state
  end
end

FactoryGirl.define do
  factory :user do |f|
    sequence(:name) {|n| "User #{n}" }
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
