class Dashboard::TransactionsController < ApplicationController
  include Dashboard::TransactionsHelper
  before_action :authenticate_user!
  before_action :set_policy!, only: :index


  def index
    if params[:q] && params[:q][:created_at_gteq].present?
      year, month = params[:q][:created_at_gteq].split('-').map(&:to_i)
      params[:q][:created_at_gteq] = Date.new(year, month, 1)
      params[:q][:created_at_lteq] = Date.new(year, month, -1)
    end
    if current_user.landlord? || current_user.admin?
      @q = Transaction.ransack(params[:q])
      @pagy, @transactions = pagy(@q.result.where(status: :under_review).where.not(transaction_type: 'refund_request').order(created_at: :desc),distinct: true)
    else
      @q = current_user.transactions.ransack(params[:q])
      @pagy, @transactions = pagy(@q.result.order(created_at: :desc).where(status: :under_review), distinct: true)
    end
  end


  def mark_as_paid
    @transaction = Transaction.find(params[:id])
    if @transaction.update(status: :done)
      redirect_to dashboard_transactions_path, notice: 'Transaction marked as paid.'
    else
      redirect_to dashboard_transactions_path, alert: 'Failed to update transaction status.'
    end
  end

  def mark_as_rejected
    @transaction = Transaction.find(params[:id])
    if @transaction.update(status: :rejected, reason: transaction_params[:reason])
      redirect_to dashboard_transactions_path, notice: 'Transaction marked as rejected with a reason.'
    else
      redirect_to dashboard_transactions_path, alert: 'Failed to update transaction status.'
    end
  end

  def mark_as_done
    @transaction = Transaction.find(params[:id])
    if @transaction.update(status: :done)
      redirect_to dashboard_transactions_path, notice: 'Transaction marked as done.'
    else
      redirect_to dashboard_transactions_path, alert: 'Failed to update transaction status.'
    end
  end

  private

  def set_policy!
    authorize User, policy_class: Dashboard::TransactionsPolicy
  end

  def transaction_params
    params.require(:transaction).permit(:reason)
  end
end
