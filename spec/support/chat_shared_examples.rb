shared_examples "chat controller action" do
    it "should return 401 Unauthorized if the user is non the given chatroom" do
      controller.should_receive(:logged_user).and_return(malicious)
      get :index, :chatroom_id => chatroom.id
      response.status.should == 401
    end

  it "should return 404 without chatroom_id" do
    expect{get :index}.to raise_error(ActionController::RoutingError)
  end
end
