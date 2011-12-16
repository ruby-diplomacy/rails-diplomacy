require 'dm-rails/middleware/identity_map'

class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap
  protect_from_forgery


  def logged_user
    User.first
  end
end
