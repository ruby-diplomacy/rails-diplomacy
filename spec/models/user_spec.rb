require 'spec_helper'

describe User do
  it "it cannot have a duplicate email address" do
    @user1=User.new(email:"test@test.com")
    @user1.save!
    @user2=User.new(email:"TEST@test.com")
    @user2.should_not be_valid
  end
end