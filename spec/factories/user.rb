FactoryGirl.define do
   factory :user do
    sequence(:username) {|n| "user_#{n}"}
    email {"#{username}@example.com"}
    password 'password'
  end
end
