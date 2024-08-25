class Dashboard::TenantsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tenant, only: %i[destroy]

  def index
    @q = User.tenant.ransack(search_params)
    @pagy, @tenants = pagy(@q.result.order(created_at: :desc), distinct: :true)
  end


  def new
    @tenant = User.new
    @tenant.build_tenant
  end

  def create
    @tenant = User.new(tenant_params)
    @tenant.generated_password = tenant_params[:password]
    if @tenant.save
      redirect_to dashboard_tenants_path, notice: "New Tenant successfully created"
    else
      redirect_to dashboard_tenants_path, alert: @tenant.errors.full_messages.first
    end
  end


  def destroy
    if @tenant.destroy
      redirect_to dashboard_tenants_path, notice: "Tenant successfully removed"
    else
      redirect_to dashboard_tenants_path, alert: @tenant.errors.full_messages.first
    end
  end

  private

  def set_tenant
    @tenant = User.find(params[:id])
  end

  def tenant_params
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
      tenant_attributes: [:property_id, :property_unit_id, :room_id, :deck, :check_in]
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
