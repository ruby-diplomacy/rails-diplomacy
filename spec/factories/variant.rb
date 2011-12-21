FactoryGirl.define  do
  factory :variant do 
    sequence(:name) {|n| "variant_#{n}"}
    factory :variant_with_powers do 
      powers {FactoryGirl.create_list(:power, 7)}
    end
  end
end
