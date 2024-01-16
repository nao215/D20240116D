module UserService
  class Authenticate < BaseService
    def self.call(username, password_hash)
      user = User.find_by(username: username)

      if user.nil?
        return { message: I18n.t('devise.failure.not_found_in_database', authentication_keys: 'username') }
      end

      unless user.password_hash == password_hash
        return { message: I18n.t('devise.failure.invalid') }
      end

      unless user.email_confirmed
        return { message: I18n.t('devise.failure.unconfirmed') }
      end

      session_token = generate_session_token(user)

      {
        user_id: user.id,
        session_token: session_token,
        message: I18n.t('devise.sessions.signed_in')
      }
    end

    private

    def self.generate_session_token(user)
      # Assuming there's a method to generate a secure token for the session
      SecureRandom.hex(10) # This is just a placeholder implementation
    end
  end
end
