class ApplicationController < ActionController::Base
  protect_from_forgery


  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private
  def after_sign_in_path_for(resource_or_scope)
    if current_user.role == 'admin'
      admin_root_path
    else
      customer_root_path
    end
  end
end
