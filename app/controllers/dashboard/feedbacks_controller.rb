class Dashboard::FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy!

  def index
    @q = Payment.ransack(params[:q])
    if current_user.landlord? || current_user.admin?
      @pagy, @feedbacks = pagy(@q.result.where.not(suggestion: nil).order(created_at: :asc), distinct: true)
    else
      @pagy, @feedbacks = pagy(@q.result.where(user: current_user).where.not(suggestion: nil).order(created_at: :asc), distinct: true)
    end
  end

  private

  def set_policy!
    authorize User, policy_class: Dashboard::FeedbacksPolicy
  end
end
