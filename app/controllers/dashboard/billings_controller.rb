class Dashboard::BillingsController < ApplicationController
  include Dashboard::BillingsHelper
  before_action :authenticate_user!
  before_action :set_billing, only: [:show, :destroy]
  before_action :get_billing_id, only: :billing_data\

  def index
    if current_user.landlord? || current_user.admin?
      @q = Billing.ransack(params[:q])
      @pagy, @billings = pagy(@q.result.order(created_at: :desc), distinct: :true)
    else
      @q = Billing.joins(:charges).where(charges: { user_id: current_user.id }).distinct.ransack(params[:q])
      @pagy, @billings = pagy(@q.result.order(created_at: :desc), distinct: :true)
    end
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

  def show
    @property_units = @billing.property.property_units
    @billing_charges = @billing.charges.order(created_at: :desc)
  end

  def billing_data
    render json: {
      total_paid: @billing.total_paid_amount.round(2),
      total_amount: @billing.total_charges_amount.round(2),
      total_water_billing_amount: @billing.total_water_billing_amount.round(2),
      total_water_billing_paid_amount: @billing.total_water_billing_paid_amount.round(2),
      total_electricity_billing_amount: @billing.total_electricity_billing_amount.round(2),
      total_electricity_billing_paid_amount: @billing.total_electricity_billing_paid_amount.round(2),
      total_wifi_billing_amount: @billing.total_wifi_billing_amount.round(2),
      total_wifi_billing_paid_amount: @billing.total_wifi_billing_paid_amount.round(2),
      total_monthly_rental_billing_amount: @billing.total_monthly_rental_billing_amount.round(2),
      total_monthly_rental_billing_paid_amount: @billing.total_monthly_rental_billing_paid_amount.round(2)
    }
  end

  private

  def set_billing
    @billing = Billing.find_by(number: params.dig(:id))
    redirect_to dashboard_billings_path, alert: "Billing not exist!" if @billing.nil?
  end

  def get_billing_id
    @billing = Billing.find_by(id: params[:id])
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
