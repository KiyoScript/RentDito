class Dashboard::UtilityStaffController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy!

  def index
    @q = User.utility_staff.ransack(search_params)
    @pagy, @utility_staff = pagy(@q.result.order(created_at: :desc), distinct: :true)
  end


  def new
    @utility_staff = User.new
    @utility_staff.build_utility_staff
  end

  def create
    @utility_staff = User.new(utility_staff_params)
    @utility_staff.generated_password = utility_staff_params[:password]
    if @utility_staff.save
      redirect_to dashboard_utility_staff_index_path, notice: "New Caretaker successfully created"
    else
      redirect_to dashboard_utility_staff_index_path, alert: @utility_staff.errors.full_messages.first
    end
  end

  private

  def set_policy!
    authorize User, policy_class: Dashboard::UtilityStaffPolicy
  end

  def utility_staff_params
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
      utility_staff_attributes: [:property_id, :property_unit_id, :room_id, :deck, :check_in]
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
    # Return the mapped value from the enum hash, or nil if not present
    enum_hash[value.to_s] if value.present?
  end
end
