module Api
  class UsersController < Api::BaseController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity

    def login
      username = params[:username]
      password = params[:password]

      # Validate parameters
      return render json: { error: "Username is required." }, status: :bad_request if username.blank?
      return render json: { error: "Password is required." }, status: :bad_request if password.blank?

      # Authenticate user
      result = UserService::Authenticate.authenticate(username_or_email: username, password: password, ip_address: request.remote_ip)

      if result[:token]
        render json: { status: 200, message: "Login successful.", access_token: result[:token] }, status: :ok
      elsif result[:error] == 'Authentication failed' || result[:error] == 'Invalid password'
        render json: { error: result[:error] }, status: :unauthorized
      else
        render json: { error: result[:error] }, status: :internal_server_error
      end
    end

    def confirm_email
      token = params.require(:token)
      result = ConfirmationTokenService::Validate.call(token)
      render json: { status: 200, message: result[:message] }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render_not_found
    rescue ActiveRecord::RecordInvalid
      render_unprocessable_entity
    rescue StandardError => e
      render json: { message: e.message }, status: :internal_server_error
    end

    private

    def render_not_found
      render json: { message: "Invalid or expired token." }, status: :not_found
    end

    def render_unprocessable_entity
      render json: { message: "Invalid or expired token." }, status: :unprocessable_entity
    end
  end
end
