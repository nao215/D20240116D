# frozen_string_literal: true

module Api
  class TwoFactorAuthController < BaseController
    before_action :doorkeeper_authorize!

    def initiate
      user_id = params.require(:user_id)
      user = User.find_by(id: user_id)

      return render json: { error: 'User not found.' }, status: :not_found unless user
      return render json: { error: 'User does not have 2FA enabled.' }, status: :forbidden unless user.two_factor_enabled

      two_factor_service = TwoFactorAuthenticationService.new
      two_factor_service.send_code_to_user(user_id)
      render json: {
        status: 200,
        message: 'Two-factor authentication initiated.',
        '2fa_token': two_factor_service.generate_code(user_id)
      }, status: :ok
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
    end
  end
end
