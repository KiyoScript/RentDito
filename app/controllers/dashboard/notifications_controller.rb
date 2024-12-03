class Dashboard::NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_policy!, only: :index
  def index
    @q = current_user.notifications.ransack(params[:q])
    @pagy, @notifications = pagy(@q.result.order(read: :asc, created_at: :desc),distinct: true)
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    head :ok
  end

  def mark_all_as_read
    current_user.notifications.update_all(read: true)
    head :ok
  end

  private

  def set_policy!
    authorize User, policy_class: Dashboard::NotificationsPolicy
  end

end
