class Dashboard::HomepageController < ApplicationController
  before_action :redirect_to_onbarding
  def index;end


  private

  def redirect_to_onbarding
    redirect_to onboarding_path(current_user), notice: "Your account is awaiting verification. Please wait for the Landlord's approval." if current_user.unverified?
  end
end
