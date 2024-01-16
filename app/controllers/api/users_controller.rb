module Api
  class UsersController < Api::BaseController
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
  end
end
