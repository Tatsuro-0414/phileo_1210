class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :store_user_location!, if: :storable_location?

  private

  def redirect_root
    redirect_to orders_path unless user_signed_in?
  end

  private

  def storable_location?
    controller_name != 'members' &&
    controller_name != 'orders' &&
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
  end

  def store_user_location!
   session[:return_to_url] = request.fullpath
  end

end
