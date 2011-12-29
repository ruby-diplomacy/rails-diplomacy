require 'faye'
require File.expand_path('../config/initializers/faye.rb', __FILE__)

class ServerAuth
  def self.incoming_message(message, callback)
    if message['channel'] !~ %r{^/meta/}
      if message['ext']['auth_token'] != FayeSettings::secrutiry_token
        message['error'] = 'Access Denied!'
        puts "Message Denied!! #{message}"
      end
    end
    callback.call(message)
  end
end


faye_server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 45)
Faye::Logging.log_level = :debug
Faye.logger = lambda { |m| puts m } 
faye_server.add_extension(ServerAuth)
run faye_server
