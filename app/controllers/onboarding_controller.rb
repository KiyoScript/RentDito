class OnboardingController < ApplicationController
  layout "onboarding", only: [:show, :update]
  before_action :set_user

  def show; end

  def update
    filtered_params = filter_password_params(user_params)

    if filtered_params[:signature].present?
      attach_signature(filtered_params[:signature])
      filtered_params.delete(:signature)
    end

    if @user.update(filtered_params)
      sign_in(@user, bypass: true)
      flash[:notice] = success_message(filtered_params)
      redirect_to onboarding_path(@user)
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      redirect_to onboarding_path(@user)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :firstname,
      :lastname,
      :email,
      :phone_number,
      :gender,
      :age,
      :status,
      :role,
      :password,
      :password_confirmation,
      :avatar,
      :signature,
      :first_valid_id,
      :second_valid_id,
      :first_contact_name,
      :first_contact_number,
      :first_relationship,
      :second_contact_name,
      :second_contact_number,
      :second_relationship,
      :third_contact_number,
      :fourth_contact_number
    )
  end

  def attach_signature(signature_data)
    if signature_data.present?
      decoded_image = decode_base64_image(signature_data)
      if decoded_image
        @user.signature.attach(io: StringIO.new(decoded_image), filename: "signature.png", content_type: "image/png")
      else
        Rails.logger.debug("Failed to decode image.")
        flash[:alert] = "Failed to decode the signature image. Please try again."
      end
    else
      Rails.logger.debug("Signature data is missing or invalid.")
      flash[:alert] = "Signature data is missing or invalid. Please try again."
    end
  end

  def decode_base64_image(data_uri)
    if data_uri.present? && data_uri.include?(",")
      encoded_image = data_uri.split(",")[1]
      Base64.decode64(encoded_image)
    else
      Rails.logger.debug("Invalid data URI: #{data_uri}")
      nil
    end
  end

  def filter_password_params(params)
    return params.except(:password, :password_confirmation) if params[:password].blank?
    params
  end

  def success_message(params)
    if params.key?(:password)
      "Your account is awaiting verification. Please wait for the Landlord's approval."
    else
      "Your profile has been updated successfully."
    end
  end
end
