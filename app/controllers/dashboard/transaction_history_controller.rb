class Dashboard::TransactionHistoryController < ApplicationController
 include Dashboard::TransactionsHelper
  before_action :authenticate_user!

  def index
    if current_user.landlord? || current_user.admin?
      @q = Transaction.ransack(params[:q])
      @pagy, @transaction_history = pagy(@q.result.order(created_at: :desc).where(status: [:done, :rejected], transaction_type: [:payment, :deposit]), distinct: true)
    else
      @q = current_user.transactions.ransack(params[:q])
      @pagy, @transaction_history = pagy(@q.result.order(created_at: :desc).where(status: [:done, :rejected]), distinct: true)
    end
  end
end
