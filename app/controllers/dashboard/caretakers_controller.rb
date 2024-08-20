class Dashboard::CaretakersController < ApplicationController
  before_action :set_caretaker, only: %i[destroy]

  def index
    @q = User.caretaker.ransack(search_params)
    @pagy, @caretakers = pagy(@q.result.order(created_at: :desc))
  end


  def new
    @caretaker = User.new
    @caretaker.build_caretaker
  end
  def create
    @caretaker = User.new(caretaker_params)
    @caretaker.generated_password = caretaker_params[:password]
    if @caretaker.save
      redirect_to dashboard_caretakers_path, notice: "Successfully created"
    else
      redirect_to dashboard_caretakers_path, alert: @caretaker.errors.full_messages.first
    end
  end


  def destroy
    if @caretaker.destroy
      redirect_to dashboard_caretakers_path, notice: "Caretaker Successfully removed"
    else
      render :new, alert: @caretaker.errors.full_messages.first
    end
  end

  private

  def set_caretaker
    @caretaker = User.find(params[:id])
  end

  def caretaker_params
    params.require(:user).permit(
      :firstname,
      :lastname,
      :email,
      :phone_number,
      :gender,
      :status,
      :role,
      :password,
      :password_confirmation,
      caretaker_attributes: [:address, :bh_numbers]
    )
  end

  def search_params
    q_params = params.fetch(:q, {})
              .permit(:status_eq, :gender_eq)
              {
                status_eq: map_enum_value(User.statuses, q_params[:status_eq]),
                gender_eq: map_enum_value(User.genders, q_params[:gender_eq])
              }.compact
  end

  def map_enum_value(enum_hash, value)
    # Return the mapped value from the enum hash, or nil if not present
    enum_hash[value.to_s] if value.present?
  end
end
