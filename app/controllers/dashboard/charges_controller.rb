class Dashboard::ChargesController < ApplicationController
  include Dashboard::BillingsHelper

  before_action :authenticate_user!
  before_action :set_billing_and_charge, only: [:edit, :update]
  before_action :set_policy!
  def index
    @q = current_user.charges.ransack(params[:q])
    @pagy, @charges = pagy(@q.result.order(created_at: :desc).where(status: :unpaid), distinct: :true)
  end
  def edit;end

  def update
    @charge.number_of_days = billing_charge_params[:days_count]
    if @charge.update(billing_charge_params)
      redirect_to dashboard_billing_path(@billing.number), notice: "#{@charge.user.firstname}'s biiling successfully updated"
    else
      redirect_to dashboard_billing_path(@billing.number), alert: @charges.errors.full_messages.first
    end
  end

  private


  def set_policy!
    authorize User, policy_class: Dashboard::ChargesPolicy
  end

  def set_billing_and_charge
    @billing = Billing.find(params[:billing_id])
    @charge = @billing.charges.find(params[:id])
  end

  def billing_charge_params
    params.require(:charge).permit(:extra_charge_amount, :electricity_share_amount, :water_share_amount, :wifi_share_amount, :monthly_rental_amount, :total_amount, :days_count)
  end
end
