
# frozen_string_literal: true

module TwoFactorService
  class Initiate
    def self.initiate(user_id)
      user = User.find_by(id: user_id)
      return { error: 'User not found.', status: 401 } unless user

      if user.two_factor_enabled
        two_factor_auth_service = TwoFactorAuthenticationService.new
        token = two_factor_auth_service.generate_code(user_id)
        two_factor_auth_service.send_code_to_user(user_id)
        { status: 200, message: 'Two-factor authentication initiated.', '2fa_token': token }
      else
        { error: 'User does not have 2FA enabled.', status: 403 }
      end
    rescue StandardError => e
      { error: "Two-factor authentication initiation failed: #{e.message}", status: 500 }
    end
  end
end
