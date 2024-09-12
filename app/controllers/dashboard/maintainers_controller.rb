class Dashboard::MaintainersController < ApplicationController
  before_action :set_maintainer, only: %i[destroy]
  before_action :redirect_to_onbarding

  def index
    @q = User.maintainer.ransack(search_params)
    @pagy, @maintainers = pagy(@q.result.order(created_at: :desc), distinct: :true)
  end


  def new
    @maintainer = User.new
    @maintainer.build_maintainer
  end

  def create
    @maintainer = User.new(maintainer_params)
    @maintainer.generated_password = maintainer_params[:password]
    if @maintainer.save
      redirect_to dashboard_maintainers_path, notice: "New Maintainer successfully created"
    else
      redirect_to dashboard_maintainers_path, alert: @maintainer.errors.full_messages.first
    end
  end


  def destroy
    if @maintainer.destroy
      redirect_to dashboard_maintainers_path, notice: "Maintainer successfully removed"
    else
      redirect_to dashboard_maintainers_path, alert: @maintainer.errors.full_messages.first
    end
  end

  private

  def set_maintainer
    @maintainer = User.find(params[:id])
  end

  def maintainer_params
    params.require(:user).permit(
      :firstname,
      :lastname,
      :email,
      :phone_number,
      :gender,
      :status,
      :role,
      :password,
      :password_confirmation,
      maintainer_attributes: [:city]
    )
  end

  def search_params
    q_params = params.fetch(:q, {}).permit(:firstname_or_lastname_or_email_cont, :status_eq, :gender_eq)
    {
      firstname_or_lastname_or_email_cont: q_params[:firstname_or_lastname_or_email_cont],
      status_eq: map_enum_value(User.statuses, q_params[:status_eq]),
      gender_eq: map_enum_value(User.genders, q_params[:gender_eq]),
    }.compact
  end


  def map_enum_value(enum_hash, value)
    enum_hash[value.to_s] if value.present?
  end

  def redirect_to_onbarding
    redirect_to onboarding_path(current_user), notice: "Your account is awaiting verification. Please wait for the Landlord's approval." if current_user.unverified?
  end
end
