module ApplicationHelper
  def push_to_message_server(channel, &block)
    message = {:channel => channel, :data => capture(&block), :ext => FayeSettings::security_token}
    uri = URI.parse(FayeSettings::SERVER_URL + '/faye')
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def channel_for_message(message)
    channel_for_chatroom(message.chatroom)
  end

  def channel_for_chatroom(chatroom)
    "/chatrooms/#{chatroom.id}"
  end
end
