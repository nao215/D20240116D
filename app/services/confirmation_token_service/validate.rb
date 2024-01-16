module ConfirmationTokenService
  class Validate
    def self.call(token)
      confirmation_token = ConfirmationToken.find_by(token: token, used: false)
      if confirmation_token && confirmation_token.expires_at > Time.current
        confirmation_token.update!(used: true)
        user = confirmation_token.user
        user.update!(email_confirmed: true)

        { user_id: user.id, email_confirmed: user.email_confirmed, message: 'Email has been successfully confirmed.' }
      else
        raise StandardError.new('Token is invalid or expired')
      end
    rescue StandardError => e
      # Log the error message
      Rails.logger.error "ConfirmationTokenService::Validate Error: #{e.message}"
      # Re-raise the error to be handled by the caller
      raise
    end
  end
end

# Note: The above code assumes that the ConfirmationToken and User models are already defined and
# that the ConfirmationToken model has a 'used' attribute and an 'expires_at' attribute.
# It also assumes that the User model has an 'email_confirmed' attribute.
