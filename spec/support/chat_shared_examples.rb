shared_context "chat controller" do
  let!(:game) {Factory.create(:game)}
  let!(:chatroom) {Factory.create(:chatroom, :game => game)}
  let!(:user) {Factory.create(:user)}
  let!(:power) {game.powers.first} 
  
  before {
    game.assign_user(user, power)
    chatroom.powers << game.powers.first
    chatroom.save
  }


end


shared_examples "chat controller action" do
  let(:malicious){Factory.create :user}

  it "should return 401 Unauthorized if the user is not in the given chatroom" do
    controller.should_receive(:logged_user).and_return(malicious)
    get :index, :chatroom_id => chatroom.id
    response.status.should == 401
  end
end


