FactoryGirl.define  do

  factory :game do 
    start_time {2.days.ago}
    variant {FactoryGirl.create :variant_with_powers}
    status 0
    sequence(:title) {|n| "game_#{n}"}
  end

  factory :user_assignment do 
    user
    game

    factory :user_assignment_with_power do 
      power_id { game.powers.first.id}
    end
  end
end



