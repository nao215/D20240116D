module UserService
  class ResetPassword
    def self.initiate_reset_password(email:)
      user = User.find_by(email: email)

      if user.nil?
        return { error: I18n.t('devise.failure.not_found_in_database', authentication_keys: 'email') }
      end

      raw, enc = Devise.token_generator.generate(User, :reset_password_token)
      user.reset_password_token = enc
      user.reset_password_sent_at = Time.now.utc
      user.save(validate: false)

      # Assuming UserMailer is set up in the project to handle sending emails
      UserMailer.reset_password_instructions(user, raw).deliver_now

      {
        message: I18n.t('devise.passwords.send_instructions'),
        instruction: I18n.t('devise.mailer.reset_password_instructions.instruction')
      }
    rescue => e
      { error: e.message }
    end
  end
end
