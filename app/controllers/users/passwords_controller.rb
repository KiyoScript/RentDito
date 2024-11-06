# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end
  #
  def create
    resource = User.find_by(email: resource_params.dig(:email))
    token = resource.send(:set_reset_password_token)
    if successfully_sent?(resource)
      ResetPasswordInstructionsMailer.send_email(resource, token).deliver_now
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with resource
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
