class Dashboard::DepositsController < ApplicationController
  before_action :authenticate_user!

  def new
    @deposit = current_user.deposits.new
  end


  def create
    @deposit = current_user.deposits.new(deposit_params)
    @deposit.date_time = DateTime.now if @deposit.date_time.blank?
    if @deposit.save
      redirect_to root_path, notice: "Deposit successful! Please wait for verification from the landlord"
    else
      redirect_to root_path, alert: @deposit.errors.full_messages.first
    end
  end


  private

  def deposit_params
    params.require(:deposit).permit(:amount, :receipt, :reference_number, :date_time)
  end
end
