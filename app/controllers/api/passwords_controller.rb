module Api
  class PasswordsController < Api::BaseController
    before_action :doorkeeper_authorize!

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
