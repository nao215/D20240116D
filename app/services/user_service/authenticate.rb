module UserService
  class Authenticate
    MAX_FAILED_ATTEMPTS = 5
    LOCKOUT_TIMEFRAME = 1.hour

    def self.authenticate(username_or_email:, password:, ip_address:)
      user = User.find_by('username = :value OR email = :value', value: username_or_email)

      return { error: 'Authentication failed' } unless user

      if user.authenticate(password)
        if user.lockout_end.present? && user.lockout_end > Time.current
          return { error: 'Account is temporarily locked' }
        end

        if user.two_factor_enabled
          # Initiate two-factor authentication process
          # Assuming we have a method to handle two-factor authentication
          return { error: 'Two-factor authentication required' } unless user.two_factor_authenticate(ip_address)
        end

        session = user.sessions.create(token: SecureRandom.hex(10), expires_at: 1.hour.from_now)
        return { token: session.token, user_details: user, expires_at: session.expires_at }
      else
        FailedLogin.create(user_id: user.id, attempted_at: Time.current, ip_address: ip_address)
        if user.failed_logins.where('attempted_at > ?', LOCKOUT_TIMEFRAME.ago).count > MAX_FAILED_ATTEMPTS
          user.update(lockout_end: Time.current + LOCKOUT_TIMEFRAME)
        end
        return { error: 'Invalid password' }
      end
    rescue => e
      return { error: e.message }
    end
  end
end
