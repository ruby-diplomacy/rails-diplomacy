FactoryGirl.define do
  sequence :nationality {|n| "nationality #{n}"}

  factory :unit do
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
