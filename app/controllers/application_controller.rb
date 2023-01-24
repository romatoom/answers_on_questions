class ApplicationController < ActionController::Base
  add_flash_types :success, :warning

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to new_user_session_path, alert: "#{exception.message} Please sign in or sign up first to get more features."
  end

  check_authorization :unless => :do_not_check_authorization?

  private

  def do_not_check_authorization?
    devise_controller? || controller_name == 'confirmed_emails'
  end
end
