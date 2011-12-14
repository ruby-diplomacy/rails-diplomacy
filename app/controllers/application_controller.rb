class ApplicationController < ActionController::Base
  protect_from_forgery


  def logged_user
    User.first
  end
end
