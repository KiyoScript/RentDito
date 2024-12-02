class Dashboard::TransactionHistoryController < ApplicationController
 include Dashboard::TransactionsHelper
  before_action :authenticate_user!

  def index
    if current_user.landlord? || current_user.admin?
      @q = Transaction.ransack(params[:q])
      @pagy, @transaction_history = pagy(@q.result.where(status: [:done, :rejected]).where(transaction_type: [:payment, :deposit]).or(@q.result.where(transaction_type: 'refund_request').where(status: 'under_review').where.not(amount_cents: 0)).order(created_at: :desc),distinct: true)
    else
      @q = current_user.transactions.ransack(params[:q])
      @pagy, @transaction_history = pagy(@q.result.order(created_at: :desc).where(status: [:done, :rejected]), distinct: true)
    end
  end
end
