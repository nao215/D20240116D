module Api
  class UsersController < ApplicationController
    before_action :validate_user_params, only: [:register]

    # POST /api/users/register
    def register
      user = User.new(user_params)
      if user.save
        render json: {
          status: 201,
          message: "User registered successfully.",
          user: user_response(user)
        }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :conflict
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    # POST /api/users/login
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

    private

    def user_params
      params.require(:user).permit(:username, :password, :email, :phone_number)
    end

    def validate_user_params
      required_params = %w[username password email phone_number]
      required_params.each do |param|
        if params[param].blank?
          render json: { error: "#{param.humanize} is required." }, status: :bad_request
          return
        end
      end
      # Add additional validations for password, email, and phone_number here
    end

    def user_response(user)
      {
        id: user.id,
        username: user.username,
        email: user.email,
        phone_number: user.phone_number,
        created_at: user.created_at.iso8601
      }
    end
  end
end
