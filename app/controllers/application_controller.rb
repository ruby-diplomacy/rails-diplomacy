require 'dm-rails/middleware/identity_map'

class ApplicationController < ActionController::Base
  use Rails::DataMapper::Middleware::IdentityMap

  rescue_from DataMapper::ObjectNotFoundError, :with => :record_not_found
  rescue_from User::NotAuthorizedError, :with  => :user_not_authorized
  protect_from_forgery

  # FIXME: stub
  def require_login
    @user = logged_user
  end
  
  # FIXME: authentication
  def logged_user
    User.first
  end

  def record_not_found
    render_error(404)
  end

  def user_not_authorized
    render_error(401)
  end

  def render_error(code)
    render :file => "public/#{code}.html", :status => code
  end
end
