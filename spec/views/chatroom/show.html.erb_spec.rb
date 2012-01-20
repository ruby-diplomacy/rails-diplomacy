require 'spec_helper'

describe "chatroom/show.html.erb", :js => true do
  let(:game) {Factory.create :game}
  let(:user) {Factory.create :user}
  
  before {game.assign_user(user, Power.first)}

  describe "should display the message" do

  end
end
