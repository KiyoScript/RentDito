class Dashboard::TransactionHistoryController < ApplicationController
 include Dashboard::TransactionsHelper
  before_action :authenticate_user!

  def index
    if current_user.landlord?
      @q = Transaction.ransack(params[:q])
      @pagy, @transaction_history = pagy(@q.result.order(created_at: :desc).where(status: :done), distinct: true)
    else
      @q = current_user.transactions.ransack(params[:q])
      @pagy, @transaction_history = pagy(@q.result.order(created_at: :desc).where(status: :done), distinct: true)
    end
  end
end
