class Dashboard::MaintenanceStaffsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy!

  def index
    @q = User.maintenance_staff.ransack(search_params)
    @pagy, @maintenance_staffs = pagy(@q.result.order(created_at: :desc), distinct: :true)
  end


  def new
    @maintenance_staff = User.new
    @maintenance_staff.build_maintenance_staff
  end

  def create
    @maintenance_staff = User.new(maintenance_staff_params)
    @maintenance_staff.generated_password = maintenance_staff_params[:password]
    if @maintenance_staff.save
      redirect_to dashboard_maintenance_staffs_path, notice: "New Maintenance Staff successfully created"
    else
      redirect_to dashboard_maintenance_staffs_path, alert: @maintenance_staff.errors.full_messages.first
    end
  end


  private

  def set_policy!
    authorize User, policy_class: Dashboard::MaintenanceStaffsPolicy
  end

  def maintenance_staff_params
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
      maintenance_staff_attributes: [:city]
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
end
