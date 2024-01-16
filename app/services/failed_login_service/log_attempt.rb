module FailedLoginService
  class LogAttempt
    def self.log_attempt(user_id:, ip_address:)
      begin
        FailedLogin.create!(
          user_id: user_id,
          attempted_at: Time.current,
          ip_address: ip_address
        )
      rescue => e
        Rails.logger.error "Failed to log failed login attempt: #{e.message}"
      end
    end
  end
end
