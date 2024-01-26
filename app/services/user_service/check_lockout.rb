module UserService
  class CheckLockout
    LOCKOUT_THRESHOLD = 5 # Number of failed attempts allowed
    LOCKOUT_TIMEFRAME = 1.hour # Timeframe for counting failed attempts

    def self.check_lockout(user_id:)
      user = User.find_by(id: user_id)
      return false unless user

      failed_attempts = user.failed_logins.where('attempted_at > ?', LOCKOUT_TIMEFRAME.ago).count

      if failed_attempts >= LOCKOUT_THRESHOLD
        user.update(lockout_end: Time.current + LOCKOUT_TIMEFRAME)
        return true
      end

      false
    rescue => e
      # Here you would handle exceptions and log errors as appropriate for your application
      Rails.logger.error("UserService::CheckLockout error: #{e.message}")
      false
    end
  end
end
