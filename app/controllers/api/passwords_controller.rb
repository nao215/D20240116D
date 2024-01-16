module Api
  class PasswordsController < Api::BaseController
    before_action :doorkeeper_authorize!
    
    def request_password_reset
      email = params[:email]

      unless UserService::ValidateEmail.validate_email(email)
        return render json: { error: "Invalid email address." }, status: :unprocessable_entity
      end

      result = UserService::ResetPasswordRequest.new.handle_reset_password_request(email)

      if result.nil?
        render json: { error: "An unexpected error occurred." }, status: :internal_server_error
      elsif User.find_by(email: email).nil?
        render json: { error: "Email not found." }, status: :not_found
      else
        render json: { status: 200, message: "Password reset link sent successfully." }, status: :ok
      end
    end

    # POST /api/users/confirm-password-reset
    def confirm_password_reset
      token = params[:token]
      new_password = params[:new_password]

      # Validate the new password strength
      unless new_password.match(User::PASSWORD_FORMAT)
        return render json: { error: "Password must be at least 8 characters long and include a combination of letters, numbers, and special characters." }, status: :unprocessable_entity
      end

      # Validate and consume the token
      result = ConfirmationTokenService::ValidateAndConsume.validate_and_consume_token(token)
      if result.nil?
        return render json: { error: "Invalid or expired token." }, status: :not_found
      end

      # Update the user's password
      update_result = UpdatePasswordService.new.confirm_reset_password(token: token, password_hash: new_password)
      if update_result[:success]
        render json: { status: 200, message: update_result[:message] }, status: :ok
      else
        render json: { error: update_result[:message] }, status: :internal_server_error
      end
    end

    def update_password
      user_id = params[:user_id]
      new_password = params[:new_password]
      confirm_password = params[:confirm_password]

      # Validate parameters
      return render json: { error: "User not found." }, status: :not_found if User.find_by(id: user_id).nil?
      return render json: { error: "New password is required." }, status: :bad_request if new_password.blank?
      return render json: { error: "Passwords do not match." }, status: :unprocessable_entity if new_password != confirm_password

      # Call the service
      result = UpdatePasswordService.new.call(user_id: user_id, password: new_password, password_confirmation: confirm_password)

      if result[:success]
        render json: { status: 200, message: result[:message] }, status: :ok
      else
        render json: { error: result[:message] }, status: :internal_server_error
      end
    end
  end
end
