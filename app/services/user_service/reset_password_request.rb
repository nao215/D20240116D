module UserService
  class ResetPasswordRequest < BaseService
    def handle_reset_password_request(email)
      user = User.find_by(email: email)

      if user.present?
        token = SecureRandom.hex(10)
        expires_at = 2.hours.from_now

        ConfirmationToken.create!(
          user_id: user.id,
          token: token,
          expires_at: expires_at
        )

        # Send password reset email
        UserMailer.with(user: user, token: token).reset_password_instructions.deliver_now

        { email: email, message: 'If your email address exists in our database, you will receive a password reset email shortly.' }
      else
        { email: email, message: 'If your email address exists in our database, you will receive a password reset email shortly.' }
      end
    rescue StandardError => e
      logger.error "Password reset request failed: #{e.message}"
      nil
    end
  end
end

UserService::ResetPasswordRequest.new.handle_reset_password_request('user@example.com')
