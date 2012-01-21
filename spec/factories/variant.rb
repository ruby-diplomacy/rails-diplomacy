FactoryGirl.define  do
  factory :variant do 
    sequence(:name) {|n| "variant_#{n}"}
    factory :variant_with_powers do 
      after_create do |v|
        v.powers = FactoryGirl.create_list(:power, 7, :variant => v)
        v.save
      end
    end
  end
end
