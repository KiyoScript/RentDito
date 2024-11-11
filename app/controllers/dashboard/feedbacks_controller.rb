class Dashboard::FeedbacksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy!

  def index
    @q = Payment.ransack(params[:q])
    @pagy, @feedbacks = pagy(@q.result.where.not(suggestion: "").order(created_at: :desc), distinct: true)
  end

  private

  def set_policy!
    authorize User, policy_class: Dashboard::FeedbacksPolicy
  end
end
