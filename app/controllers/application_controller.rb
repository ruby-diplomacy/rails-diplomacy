
class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from User::NotAuthorizedError, :with => :not_authorized
  protect_from_forgery

  def record_not_found
    render_error(404)
  end


  def render_error(code)
    render :file => "public/#{code}.html", :status => code
  end

  def not_authorized
    render_error(401)
  end
end
