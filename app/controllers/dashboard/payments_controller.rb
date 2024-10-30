class Dashboard::PaymentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @charge = Charge.find(params[:charge_id])
    @payment = current_user.payments.new(charge: @charge)
  end

  def create
    @payment = current_user.payments.new(payments_params)
    if @payment.save
      redirect_to dashboard_charges_path, notice: 'Payment successful! Thank you for settling your charges.'
    else
      redirect_to dashboard_charges_path, alert: @payment.errors.full_messages.first
    end
  end

  private

  def payments_params
    params.require(:payment).permit(:amount, :suggestion, :charge_id)
  end
end
