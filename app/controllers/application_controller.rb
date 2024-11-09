class ApplicationController < ActionController::Base

  include Pagy::Backend
  include Pundit::Authorization

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found


  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    case policy_name

    when "onboarding_policy"
      flash[:error] = "You cannot access the onboarding process because your account status is verified"
    when "account_settings_policy"
      flash[:error] = "You just recently deactivated your account"
    else
      flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    end

    redirect_back(fallback_location: root_path)
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    return onboarding_path(resource) unless resource.verified?
    root_path
  end

  def record_not_found
    redirect_to root_path, alert: 'Record not found'
  end
end
