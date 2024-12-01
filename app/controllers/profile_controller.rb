class ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show; end


  def transfer
    room_name = @user.utility_staff? ? @user.utility_staff.room.name : @user.tenant.room.name
    user_params = @user.utility_staff? ? utility_staff_params : tenant_params

    if @user.update(user_params)
      redirect_to profile_path(@user), notice: "Transferred successfully from room #{room_name}"
    else
      redirect_to profile_path(@user), alert: @user.errors.full_messages.first
    end
  end

  def update_status
    if @user.update(status: params[:status])
      flash[:notice] = "Status updated to #{@user.status.titleize}."
      render json: { status: @user.status.titleize, flash: flash[:notice] }, status: :ok
    else
      flash[:alert] = 'Failed to update status.'
      render json: { error: flash[:alert] }, status: :unprocessable_entity
    end
  end

  def deactivate
    if @user.update(status: 'deactivated')
      redirect_to dashboard_tenants_path, notice: "Successfuly Deactivated"
    else
      redirect_to dashboard_tenants_path, alert: @user.errors.full_messages.first
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def tenant_params
    params.require(:user).permit(
      tenant_attributes: [:property_id, :property_unit_id, :room_id, :deck, :transfer_date, :check_in, :id]
    ).merge(status: 'verified')
  end

  def utility_staff_params
    params.require(:user).permit(
      utility_staff_attributes: [:property_id, :property_unit_id, :room_id, :deck, :transfer_date, :check_in, :id]
    ).merge(status: 'verified')
  end
end
