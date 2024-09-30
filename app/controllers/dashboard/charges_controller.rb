class Dashboard::ChargesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_billing_and_charge, only: [:edit, :update]

  def edit;end

  def update
    @charge.number_of_days = billing_charge_params[:days_count]
    if @charge.update(billing_charge_params)
      redirect_to dashboard_billing_path(@billing.number), notice: "Billing for #{@charge.user.fullname} successfully update"
    else
      redirect_to dashboard_billing_path(@billing.number), alert: @charges.errors.full_messages.first
    end
  end

  private

  def set_billing_and_charge
    @billing = Billing.find(params[:billing_id])
    @charge = @billing.charges.find(params[:id])
  end

  def billing_charge_params
    params.require(:charge).permit(:extra_charge_amount, :electricity_share_amount, :water_share_amount, :wifi_share_amount, :monthly_rental_amount, :total_amount, :days_count)
  end
end
