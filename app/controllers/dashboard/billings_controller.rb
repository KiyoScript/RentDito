class Dashboard::BillingsController < ApplicationController
  include Dashboard::BillingsHelper
  before_action :authenticate_user!
  before_action :set_billing, only: [:show, :destroy, :new_monthly_bill_notification]
  before_action :set_policy!, except: [:billing_data, :new_monthly_bill_notification]

  def index
    if current_user.landlord? || current_user.admin?
      @q = Billing.ransack(params[:q])
      @pagy, @billings = pagy(@q.result.order(created_at: :desc), distinct: :true)
    else
      @q = Billing.joins(:charges).where(charges: { user_id: current_user.id }).distinct.ransack(params[:q])
      @pagy, @billings = pagy(@q.result.order(created_at: :desc), distinct: :true)
    end
  end

  def show
    @property_units = @billing.property.property_units
    @billing_charges = @billing.charges.order(created_at: :desc)
  end

  def new
    @billing = current_user.billings.new
  end

  def create
    @billing = current_user.billings.new(billing_params)
    if @billing.save
      redirect_to dashboard_billings_path, notice: "Successfully created"
    else
      redirect_to new_dashboard_billing_path, alert: @billing.errors.full_messages.first
    end
  end

  def destroy
    if @billing.destroy
      redirect_to dashboard_billings_path, notice: "Succesfully deleted"
    else
      redirect_to dashboard_billings_path, alert: @billing.erros.full_messages.first
    end
  end

  def billing_data
    year_month = params[:year_month]
    year, month = year_month.split('-').map(&:to_i)

    billings = Billing.where("EXTRACT(YEAR FROM due_date) = ? AND EXTRACT(MONTH FROM due_date) = ?", year, month)

    total_paid = billings.sum(&:total_paid_amount).round(2)
    total_amount = billings.sum(&:total_charges_amount).round(2)
    total_water_billing_amount = billings.sum(&:total_water_billing_amount).round(2)
    total_water_billing_paid_amount = billings.sum(&:total_water_billing_paid_amount).round(2)
    total_electricity_billing_amount = billings.sum(&:total_electricity_billing_amount).round(2)
    total_electricity_billing_paid_amount = billings.sum(&:total_electricity_billing_paid_amount).round(2)
    total_wifi_billing_amount = billings.sum(&:total_wifi_billing_amount).round(2)
    total_wifi_billing_paid_amount = billings.sum(&:total_wifi_billing_paid_amount).round(2)
    total_monthly_rental_billing_amount = billings.sum(&:total_monthly_rental_billing_amount).round(2)
    total_monthly_rental_billing_paid_amount = billings.sum(&:total_monthly_rental_billing_paid_amount).round(2)

    render json: {
      total_paid: total_paid,
      total_amount: total_amount,
      total_water_billing_amount: total_water_billing_amount,
      total_water_billing_paid_amount: total_water_billing_paid_amount,
      total_electricity_billing_amount: total_electricity_billing_amount,
      total_electricity_billing_paid_amount: total_electricity_billing_paid_amount,
      total_wifi_billing_amount: total_wifi_billing_amount,
      total_wifi_billing_paid_amount: total_wifi_billing_paid_amount,
      total_monthly_rental_billing_amount: total_monthly_rental_billing_amount,
      total_monthly_rental_billing_paid_amount: total_monthly_rental_billing_paid_amount
    }
  end

  def new_monthly_bill_notification
    @billing.notify_all_tenants!
    redirect_to dashboard_billing_path(@billing.number), notice: "Monthly bill notification successfuly sent"
  end

  private

  def set_policy!
    authorize User, policy_class: Dashboard::BillingsPolicy
  end

  def set_billing
    @billing = Billing.find_by(number: params.dig(:id))
    redirect_to dashboard_billings_path, alert: "Billing not exist!" if @billing.nil?
  end

  def billing_params
    params.require(:billing).permit(
      :number,
      :electricity_bill_partial_amount,
      :water_bill_total_amount,
      :electricity_bill_start_date,
      :electricity_bill_end_date,
      :water_bill_start_date,
      :water_bill_end_date,
      :wifi_and_rental_start_date,
      :wifi_and_rental_end_date,
      :due_date,
      :property_id
    )
  end

end
