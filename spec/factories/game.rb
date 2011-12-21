FactoryGirl.define  do


  factory :game do 
    start_time {2.days.ago}
    variant {FactoryGirl.create :variant_with_powers}
    status 0
    sequence(:title) {|n| "game_#{n}"}
  end

  factory :game_user_assoc, :class => GameUser do 
    user
    game

    factory :game_user_assoc_with_power do 
      power_id { game.powers.first.id}
    end
  end
end


