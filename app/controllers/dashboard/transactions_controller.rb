class Dashboard::TransactionsController < ApplicationController
  include Dashboard::TransactionsHelper
  before_action :authenticate_user!

  def index
    if current_user.landlord? || current_user.admin?
      @q = Transaction.ransack(params[:q])
      @pagy, @transactions = pagy(@q.result.order(created_at: :desc), distinct: true)
    else
      @q = current_user.transactions.ransack(params[:q])
      @pagy, @transactions = pagy(@q.result.order(created_at: :desc), distinct: true)
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

  private

  def transaction_params
    params.require(:transaction).permit(:reason)
  end
end
