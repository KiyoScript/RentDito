class Dashboard::AdminsController < ApplicationController
  before_action :set_admin, only: %i[destroy]
  before_action :redirect_to_onbarding

  def index
    @q = User.admin.ransack(search_params)
    @pagy, @admins = pagy(@q.result.order(created_at: :desc), distinct: :true)
  end

  def create
    @admin = User.new(admin_params)
    @admin.generated_password = admin_params[:password]
    if @admin.save
      redirect_to dashboard_admins_path, notice: "New Admin successfully created"
    else
      redirect_to new_dashboard_admin_path, alert: @admin.errors.full_messages.first
    end
  end


  def destroy
    if @admin.destroy
      redirect_to dashboard_admins_path, notice: "Admin Successfully removed"
    else
      redirect_to dashboard_admins_path, alert: @admin.errors.full_messages.first
    end
  end

  private

  def set_admin
    @admin = User.find(params[:id])
  end

  def admin_params
    params.require(:user).permit(
      :firstname,
      :lastname,
      :email,
      :phone_number,
      :gender,
      :status,
      :role,
      :password,
      :password_confirmation
    )
  end

  def search_params
    q_params = params.fetch(:q, {})
              .permit(:firstname_or_lastname_or_email_cont, :status_eq, :gender_eq)
              {
                firstname_or_lastname_or_email_cont: q_params[:firstname_or_lastname_or_email_cont],
                status_eq: map_enum_value(User.statuses, q_params[:status_eq]),
                gender_eq: map_enum_value(User.genders, q_params[:gender_eq])
              }.compact
  end

  def map_enum_value(enum_hash, value)
    # Return the mapped value from the enum hash, or nil if not present
    enum_hash[value.to_s] if value.present?
  end

  def redirect_to_onbarding
    redirect_to onboarding_path(current_user), notice: "Your account is awaiting verification. Please wait for the Landlord's approval." if current_user.unverified?
  end
end
