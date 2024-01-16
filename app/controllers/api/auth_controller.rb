require_relative '../../models/user'
module Api
  class AuthController < BaseController
    before_action :authenticate_user

    def verify_two_factor
      user_id = params[:user_id]
      two_factor_token = params[:2fa_token]

      result = UserService::VerifyTwoFactorAuthentication.new(user_id, two_factor_token).call

      case result[:status]
      when 'success'
        render json: { status: 200, message: result[:message] }, status: :ok
      when 'error'
        case result[:message]
        when 'User not found'
          render json: { message: result[:message] }, status: :not_found
        when 'Invalid two-factor authentication code'
          render json: { message: result[:message] }, status: :unauthorized
        else
          render json: { message: result[:message] }, status: :internal_server_error
        end
      else
        render json: { message: 'An unexpected error occurred' }, status: :internal_server_error
      end
    end

    private

    def authenticate_user
      UserService::Authenticate.authenticate(email: params[:email], password: params[:password], ip_address: request.remote_ip)
    end
  end
end
