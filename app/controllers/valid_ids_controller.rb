class ValidIdsController < ApplicationController
  before_action :set_user

  def update
    if @user.update(user_params)
      render json: { success: true, message: 'Files uploaded successfully.' }
    else
      render json: { success: false, message: 'Failed to upload files.' }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_valid_id, :second_valid_id)
  end
end
