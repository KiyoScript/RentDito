class Dashboard::NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy!, only: :index
  def index
    @q = current_user.notifications.ransack(params[:q])
    @pagy, @notifications = pagy(@q.result.order(created_at: :desc), distinct: :true)
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    head :ok
  end

  private

  def set_policy!
    authorize User, policy_class: Dashboard::NotificationsPolicy
  end

end
