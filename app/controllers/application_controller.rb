class ApplicationController < ActionController::Base
  include Pagy::Backend

  private
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
