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

  factory :area_state do
    nationality
    unit
  end

end
