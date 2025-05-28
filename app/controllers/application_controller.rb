class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Authentication
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_to_onboarding, unless: :devise_controller?

  # Protection
  protect_from_forgery with: :exception

  # Flash message helpers
  add_flash_types :info, :success, :warning, :error

  # Layout configuration for Devise controllers
  layout :layout_by_resource

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :company, :role, :plan ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :company, :role, :plan ])
  end

  # Helper method for current user's assistants
  def current_user_assistants
    @current_user_assistants ||= current_user.assistants
  end

  # Helper method for current user's leads
  def current_user_leads
    @current_user_leads ||= current_user.leads
  end

  private

  def require_owner_or_admin
    redirect_to root_path, alert: "Access denied." unless current_user.owner? || current_user.admin?
  end

  def redirect_to_onboarding
    return if controller_name == 'onboarding' || current_user.nil? || current_user.onboarding_completed?
    
    redirect_to onboarding_path
  end

  def layout_by_resource
    if devise_controller?
      "authentication"
    else
      "application"
    end
  end
end
