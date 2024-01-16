module ConfirmationTokenService
  class ValidateAndConsume
    def self.validate_and_consume_token(token)
      confirmation_token = ConfirmationToken.find_by(token: token, used: false)
      if confirmation_token && confirmation_token.expires_at > Time.current
        user_id = confirmation_token.user_id
        confirmation_token.update!(used: true)
        { user_id: user_id, message: 'Password has been successfully reset.' }
      else
        raise StandardError.new('Invalid or expired token')
      end
    rescue => e
      logger.error "ConfirmationTokenService::ValidateAndConsume - Error: #{e.message}"
      nil
    end

    private

    def self.logger
      Rails.logger
    end
  end
end
