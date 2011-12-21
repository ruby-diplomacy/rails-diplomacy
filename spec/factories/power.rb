FactoryGirl.define  do
  factory :power do 
    sequence(:name) {|n| "power_#{n}"}
  end
end
