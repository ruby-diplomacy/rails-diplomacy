FactoryGirl.define do

  factory :chatroom do
    game
    powers {game.powers}
  end
end
