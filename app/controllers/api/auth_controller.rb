require_relative '../../models/user'

module Api
  class AuthController < BaseController
    include ::UserService
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
      # The new code introduces a change in the way the result of the authentication is handled.
      # We need to merge this change with the existing code.
      result = ::UserService::Authenticate.authenticate(
        username_or_email: params[:email], password: params[:password], ip_address: request.remote_ip
      )
      # The new code checks for an error in the result and renders a JSON response if there is one.
      if result[:error]
        render json: { message: result[:error] }, status: :unauthorized
      end
      # The existing code does not handle the result, so we don't need to add anything else here.
    end
  end
end
