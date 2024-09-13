class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pundit::Authorization

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    case policy_name

    when "onboarding_policy"
      flash[:error] = "You cannot access the onboarding process because your account status is verified"
    else
      flash[:error] = t "#{policy_name}.#{query_name}", scope: "pundit", default: "You are not authorized to perform this action."
    end

    redirect_back(fallback_location: root_path)
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    if resource.incomplete? || resource.deactivated?
      onboarding_path(resource)
    else
      root_path
    end
  end
end
