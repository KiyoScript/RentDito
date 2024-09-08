class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pagy::Backend

  protect_from_forgery with: :exception

  private
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    if resource.incomplete?
      onboarding_path(resource)
    else
      root_path
    end
  end
end
