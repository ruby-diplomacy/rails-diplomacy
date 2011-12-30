FactoryGirl.define do
  factory :message do 
    chatroom
    text 'some text'
  end
end
