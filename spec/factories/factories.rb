FactoryGirl.define  do
  factory :user do
    sequence(:username) {|n| "user_#{n}"}
  end

  factory :variant do 
    sequence(:name) {|n| "variant_#{n}"}
    factory :variant_with_powers do 
      powers {Factory.create_list(:power, 7)}
    end
  end

  factory :power do 
    sequence(:name) {|n| "power_#{n}"}
  end

  factory :game do 
    start_time {2.days.ago}
    variant {Factory.create :variant_with_powers}
    status 0
    sequence(:title) {|n| "game_#{n}"}
  end
end


