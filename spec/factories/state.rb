FactoryGirl.define do
  sequence :nationality do |n| 
    "nationality #{n}"
  end

  factory :unit, class: Diplomacy::Unit do
    nationality
    type 1

    factory :army do
      type 1
    end

    factory :fleet do
      type 2
    end
  end

  factory :area_state, class: Diplomacy::AreaState do
    nationality
    unit {FactoryGirl.build :unit}
  end

  sequence :area_abbrv do |n|
    "ST#{n}"
  end

  factory :game_state, class: Diplomacy::GameState do
    after_build { |g|
      4.times {|idx| g[FactoryGirl.generate :area_abbrv] = FactoryGirl.build :area_state} 
    }   
  end

end
