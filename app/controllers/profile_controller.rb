class ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show; end

  def update_status
    if @user.update(status: params[:status])
      flash[:notice] = "Status updated to #{@user.status.titleize}."
      render json: { status: @user.status.titleize, flash: flash[:notice] }, status: :ok
    else
      flash[:alert] = 'Failed to update status.'
      render json: { error: flash[:alert] }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end
end
