class BalancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy!, only: :index
  before_action :set_recipient, only: :transfer

  def index;end

  def transfer
    amount = Money.new(params[:amount].to_f * 100, 'PHP')

    if @recipient.nil?
      redirect_to root_path, alert: "Recipient not found"
    elsif @recipient == current_user
      redirect_to root_path, alert: "You cannot transfer funds to your own account"
    elsif current_user.balance.amount < amount
      redirect_to root_path, alert: "Insufficient balance for this transfer"
    else
      current_user.transfer_balance_to(@recipient, amount)
      redirect_to root_path, notice: "Transfer successful"
    end
  end


  private
  def set_policy!
    authorize User, policy_class: BalancesPolicy
  end

  def set_recipient
    @recipient = User.find_by(email: params[:recipient_email])
  end
end
