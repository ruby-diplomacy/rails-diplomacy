class ChatController < ApplicationController
  private

  def get_chatroom
    @chatroom = Chatroom.get(params[:chatroom_id])
    raise ActionController::RoutingError.new("must supply a valid chatroom id!") if @chatroom.nil?
    @chatroom
  end

  def get_power
    @power = @user.power_for_chatroom(@chatroom)
  end

  def authorized?
    @chatroom.powers.include? get_power
  end

  def user_must_belong_to_chatroom
    debugger
    raise User::NotAuthorizedError unless authorized?
  end
end

